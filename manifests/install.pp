class zookeeper::install {

  unless defined(File['/opt/tomcat']){
    file{ '/opt/tomcat':
      ensure => 'link',
      target => $zookeeper::catalina_base
    }
  }

  tomcat::instance { 'ROOT':
    install_from_source => true,
    source_url          => $zookeeper::tomcat_source_url,
    catalina_base       => $zookeeper::catalina_base,
    java_home           => $::java_default_home,
  } ->
  package {
    'zookeeper':
      ensure => $zookeeper::service_ensure;
    'netflix-exhibitor-tomcat':
      ensure  => $zookeeper::service_ensure,
      require => File['/opt/tomcat'];
  }

}
