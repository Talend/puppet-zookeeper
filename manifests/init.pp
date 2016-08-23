class zookeeper (

  $tomcat_source_url    = 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz',
  $catalina_base        = '/opt/apache-tomcat',
  $service_ensure       = running,
  $exhibitor_port       = 8080,
  $backup_enable        = false,
  $backup_bucket_name   = undef,
  $backup_bucket_prefix = undef,
  $zookeeper_nodes      = [],

) {

  contain ::zookeeper::install
  contain ::zookeeper::config
  contain ::zookeeper::service

}
