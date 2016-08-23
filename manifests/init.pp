class zookeeper (

  $tomcat_source_url  = 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz',
  $catalina_base      = '/opt/apache-tomcat',
  $service_ensure     = running,
  $zookeeper_nodes    = [],

) {

  contain ::zookeeper::install
  contain ::zookeeper::config
  contain ::zookeeper::service

}
