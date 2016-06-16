class zookeeper::service (

  $catalina_base  = $zookeeper::exhibitor_catalina_base,

){

  tomcat::service { 'exhibitor':
    catalina_base => $catalina_base,
    use_init      => false,
  }

}