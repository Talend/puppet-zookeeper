class zookeeper::install (

  $package_ensure = $zookeeper::package_ensure,

){

  package{'zookeeper':
    ensure => $package_ensure,
  }

  package{'netflix-exhibitor-tomcat':
    ensure => $package_ensure,
  }
}