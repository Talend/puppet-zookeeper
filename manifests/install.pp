class zookeeper::install (

  $package_ensure         = $zookeeper::package_ensure,
  $exibitor_catalina_base = $zookeeper::exibitor_catalina_base,
  $tomcat_version         = $zookeeper::tomcat_version,
){

  $source_url = $tomcat_version ? {
    '7'     => 'http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.69/bin/apache-tomcat-7.0.69.tar.gz',
    default => 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.2/bin/apache-tomcat-8.5.2.tar.gz'
  }


  tomcat::instance { 'ROOT':
    install_from_source => true,
    source_url          => $source_url,
    catalina_base       => $exibitor_catalina_base,
    java_home           => $::java_default_home,
  } ->

  package {
    'zookeeper':
      ensure => $package_ensure;
    'netflix-exhibitor-tomcat':
      ensure => $package_ensure;
  }
}