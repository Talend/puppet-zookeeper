class zookeeper::service (

  $service_ensure = $zookeeper::service_ensure,
  $service_enable = $zookeeper::service_eable,

){


  service{'zookeeper':
    ensure => $service_ensure,
    enable => $service_enable,
  }



}