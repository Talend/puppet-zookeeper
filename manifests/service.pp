class zookeeper::service (

  $service_ensure = $zookeeper::service_ensure,
  $service_enable = $zookeeper::service_eable,
  $catalina_base  = $zookeeper::exhibitor_catalina_base,

){


  service{'zookeeper':
    ensure => $service_ensure,
    enable => $service_enable,
  }

  tomcat::service { 'exhibitor':
    catalina_base => $catalina_base,
    use_init      => false,
  }



}