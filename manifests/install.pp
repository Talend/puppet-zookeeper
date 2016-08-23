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
  } ->
  package {
    'zookeeper':
      ensure => installed;
    'netflix-exhibitor-tomcat':
      ensure  => installed,
      require => File['/opt/tomcat'];
  }

}
