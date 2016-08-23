class zookeeper (

  $package_ensure           = $zookeeper::params::package_ensure,
  $tomcat_version           = $zookeeper::params::tomcat_version,
  $exhibitor_catalina_base  = $zookeeper::params::exhibitor_catalina_base,

) inherits zookeeper::params {

  class { 'zookeeper::install': }
  class { 'zookeeper::config': }
  class { 'zookeeper::service': }

  anchor { 'zookeeper::begin': }
  anchor { 'zookeeper::end': }

  Anchor['zookeeper::begin'] ->
  Class['zookeeper::install'] ->
  Class['zookeeper::config'] ~>
  Class['zookeeper::service'] ->
  Anchor['zookeeper::end']

}
