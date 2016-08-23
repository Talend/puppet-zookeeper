class zookeeper::config {

  require ::zookeeper::install

  #This directories have to be accessible by tomcat
  $zookeeper_dirs = [
    '/var/lib/zookeeper/data',
    '/var/lib/zookeeper',
    '/usr/lib/zookeeper/conf',
    '/usr/lib/zookeeper',
    '/var/log/zookeeper',
  ]

  file {
   "${zookeeper::catalina_base}/webapps/exhibitor/WEB-INF/classes/exhibitor.properties":
     content => template('zookeeper/exhibitor.properties.erb'),
     owner   => 'tomcat',
     group   => 'tomcat';
    $zookeeper_dirs:
      ensure => directory,
      owner  => 'tomcat',
      group  => 'tomcat';
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
