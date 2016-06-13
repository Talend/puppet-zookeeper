class zookeeper::config (

  $exhibitor_catalina_base = $zookeeper::exhibitor_catalina_base,
  $jmx_enabled = false,
  $backup_enabled = false

) {

  validate_bool($jmx_enabled)
  validate_bool($backup_enabled)


  #This directories have to be accessible by tomcat
  $zookeeper_dirs = [
    '/var/lib/zookeeper/data',
    '/var/lib/zookeeper',
    '/usr/lib/zookeeper/conf',
    '/usr/lib/zookeeper',
    '/var/log/zookeeper',
  ]

  file {
    "${exhibitor_catalina_base}/webapps/exhibitor/WEB-INF/classes/exhibitor.properties":
#                  /opt/tomcat/webapps/exhibitor/WEB-INF/classes/exhibitor.properties
      content => template('zookeeper/exhibitor.properties.erb'),
      owner   => 'tomcat',
      group   => 'tomcat';
    $zookeeper_dirs:
      ensure  => directory,
      owner   => 'tomcat',
      group   => 'tomcat';
    $unused_files:
      ensure => absent,
      force  => true;
    '/etc/init.d/zookeeper':
      content => template('zookeeper/zookeeeper.init.erb');
  }


  if $backup_enabled {
    file { '/usr/lib/zookeeper/conf/startup.properties':
      ensure  => file,
      content => template('zookeeper/startup.properties.erb'),
      owner   =>  'tomcat',
      group   =>  'tomcat',
    }
  }
}