# configuration for zookeeper and exhibitor

class zookeeper::config {

  require ::zookeeper::install

  #This directories have to be accessible by tomcat
  $zookeeper_dirs = [
    '/usr/lib/zookeeper',
    '/usr/lib/zookeeper/conf',
    '/var/lib/zookeeper',
    '/var/lib/zookeeper/data',
    '/var/lib/zookeeper/data/log',
    '/var/log/zookeeper',
  ]

  $exhibitor_port = $zookeeper::exhibitor_port

  file {
    '/opt/tomcat/webapps/exhibitor/WEB-INF/classes/exhibitor.properties':
      content => template('zookeeper/exhibitor.properties.erb'),
      owner   => 'tomcat',
      group   => 'tomcat';
    $zookeeper_dirs:
      ensure => directory,
      owner  => 'tomcat',
      group  => 'tomcat';
  }

  file {
    "${::zookeeper::zookeeper_cfg_dir}/myid":
      ensure  => file,
      content => template('zookeeper/myid.erb'),
      owner   => $zookeeper::zookeeper_user,
      group   => $zookeeper::zookeeper_user_group,
      mode    => '0644',
      require => File[$zookeeper::zookeeper_cfg_dir],
  }
}
