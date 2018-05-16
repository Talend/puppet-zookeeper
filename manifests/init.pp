# zookeeper module installation and configuration
class zookeeper (

  $tomcat_source_url    = 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz',
  $catalina_base        = '/opt/apache-tomcat',
  $service_ensure       = running,
  $service_enable       = true,
  $exhibitor_port       = 8080,
  $backup_enable        = false,
  $backup_bucket_name   = undef,
  $backup_bucket_prefix = 'exhibitor-backup',
  $zookeeper_nodes      = [],
  $zookeeper_cfg_dir    = '/var/lib/zookeeper/data',
  $zookeeper_user       = 'tomcat',
  $zookeeper_user_group = 'tomcat',

) {

  contain ::zookeeper::install
  contain ::zookeeper::config
  contain ::zookeeper::service

}
