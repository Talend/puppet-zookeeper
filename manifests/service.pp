class zookeeper::service {

  require ::zookeeper::config

  ensure_packages(['wget'])

  $config = {
    "logIndexDirectory"         => "",
    "zookeeperInstallDirectory" => "/usr/lib/zookeeper",
    "zookeeperDataDirectory"    => "/var/lib/zookeeper/data",
    "zookeeperLogDirectory"     => "",
    "serversSpec"               => "",
    "backupExtra"               => "",
    "zooCfgExtra"               => {
        "syncLimit" => "5",
        "tickTime"  => "2000",
        "initLimit" => "10",
    },
    "javaEnvironment"                      => "",
    "log4jProperties"                      => "",
    "clientPort"                           => 2181,
    "connectPort"                          => 2888,
    "electionPort"                         => 3888,
    "checkMs"                              => 30000,
    "cleanupPeriodMs"                      => 43200000,
    "cleanupMaxFiles"                      => 3,
    "backupMaxStoreMs"                     => 86400000,
    "backupPeriodMs"                       => 60000,
    "autoManageInstances"                  => 0,
    "autoManageInstancesSettlingPeriodMs"  => 180000,
    "observerThreshold"                    => 999,
    "autoManageInstancesFixedEnsembleSize" => 0,
    "autoManageInstancesApplyAllAtOnce"    => 1,
    "controlPanel"                         => {},
  }
  $config_json    = sorted_json($config)
  $exhibitor_port = $zookeeper::exhibitor_port

  tomcat::service { 'exhibitor':
    service_ensure => $zookeeper::service_ensure,
    catalina_base  => $zookeeper::catalina_base,
    use_init       => false,
  } ->
  exec { 'waiting for exhibitor to start':
    command => "/usr/bin/wget --spider --tries 15 --retry-connrefused http://localhost:${exhibitor_port}/exhibitor/exhibitor/v1/config/get-state",
    require => Package['wget']
  } ->
  exec { 'update the config':
    command => "/usr/bin/curl -X POST -d '${config_json}' http://localhost:${exhibitor_port}/exhibitor/exhibitor/v1/config/set"
  }

}
