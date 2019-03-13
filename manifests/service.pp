class zookeeper::service {

  require ::zookeeper::config

  ensure_packages(['wget'])

  $zookeeper_nodes = unique($zookeeper::zookeeper_nodes)
  $zookeeper_nodes_count = count($zookeeper_nodes)
  if ($zookeeper_nodes_count == 1) or ($zookeeper_nodes_count == 3) {
    $servers_spec = inline_template(
      '<%= @zookeeper_nodes.sort.each_with_index.map {|n, i| "S:#{i + 1}:#{n}" }.join(",") %>'
    )
  } else {
    fail("The number of nodes in the zookeeper ensemble is equal to '${$zookeeper_nodes_count}', should be either 1 or 3")
  }

  if $zookeeper::backup_enable {
    validate_string($zookeeper::backup_bucket_name)
    validate_string($zookeeper::backup_bucket_prefix)

    $backup_extra_cfg = {
      'throttle'       => '1048576',
      'bucket-name'    => $zookeeper::backup_bucket_name,
      'key-prefix'     => $zookeeper::backup_bucket_prefix,
      'max-retries'    => '3',
      'retry-sleep-ms' => '1000',
    }

    $backup_extra = inline_template('<%= @backup_extra_cfg.map { |k,v| "#{k}=#{v}" }.join("&") %>')
  } else {
    $backup_extra = ''
  }

  $config = {
    'hostname'                  => $::hostname,
    'serverId'                  => $zookeeper::config::myid,
    'logIndexDirectory'         => '/var/lib/zookeeper/data/log',
    'zookeeperInstallDirectory' => '/usr/lib/zookeeper',
    'zookeeperDataDirectory'    => '/var/lib/zookeeper/data',
    'zookeeperLogDirectory'     => '/var/log/zookeeper',
    'serversSpec'               => $servers_spec,
    'backupExtra'               => $backup_extra,
    'zooCfgExtra'               => {
        'syncLimit'             => '5',
        'tickTime'              => '2000',
        'initLimit'             => '10',
    },
    'javaEnvironment'                      => $zookeeper::zookeeper_java_env,
    'log4jProperties'                      => template('zookeeper/log4j.properties.erb'),
    'clientPort'                           => 2181,
    'connectPort'                          => 2888,
    'electionPort'                         => 3888,
    'checkMs'                              => 30000,
    'cleanupPeriodMs'                      => 43200000,
    'cleanupMaxFiles'                      => 3,
    'backupMaxStoreMs'                     => 86400000,
    'backupPeriodMs'                       => 60000,
    'autoManageInstances'                  => 0,
    'autoManageInstancesSettlingPeriodMs'  => 180000,
    'observerThreshold'                    => 999,
    'autoManageInstancesFixedEnsembleSize' => 0,
    'autoManageInstancesApplyAllAtOnce'    => 1,
    'controlPanel'                         => {},
  }
  $config_json    = sorted_json($config)
  $exhibitor_port = $zookeeper::exhibitor_port

  file { '/usr/lib/systemd/system/tomcat-exhibitor.service':
    content => template('zookeeper/tomcat.service.erb'),
  } ->
  service { 'tomcat-exhibitor':
    ensure   => $zookeeper::service_ensure,
    enable   => $zookeeper::service_enable,
    provider => 'systemd',
  }

  if $zookeeper::service_ensure != 'stopped' {
    exec { 'waiting for exhibitor to start':
      command => "/usr/bin/wget --spider --tries 15 --retry-connrefused http://localhost:${exhibitor_port}/exhibitor/v1/config/get-state",
      require => [
        Package['wget'],
        Service['tomcat-exhibitor']
      ]
    } ->
    exec { 'update the config':
      command => "/usr/bin/curl -X POST -d '${config_json}' http://localhost:${exhibitor_port}/exhibitor/v1/config/set"
    }
  }
}
