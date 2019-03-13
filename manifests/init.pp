# zookeeper module installation and configuration
class zookeeper (

  $tomcat_source_url    = 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.38/bin/apache-tomcat-8.5.38.tar.gz',
  $catalina_base        = '/opt/apache-tomcat',
  $service_ensure       = running,
  $service_enable       = true,
  $exhibitor_port       = 8080,
  $zookeeper_java_env   = '',
  $backup_enable        = false,
  $backup_bucket_name   = undef,
  $backup_bucket_prefix = 'exhibitor-backup',
  $zookeeper_nodes      = [],
  $zookeeper_cfg_dir    = '/var/lib/zookeeper/data',
  $zookeeper_user       = 'tomcat',
  $zookeeper_user_group = 'tomcat',
  $exhibitor_version    = 'installed'

) {

  anchor { '::zookeeper::begin:': }
  ->
  class { '::zookeeper::install': }
  ->
  class { '::zookeeper::config': }
  ->
  class { '::zookeeper::service': }
  ->
  anchor { '::zookeeper::end:': }

}
