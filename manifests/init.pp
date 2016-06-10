# Class: zookeeper
# ===========================
#
# Full description of class zookeeper here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'zookeeper':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class zookeeper (

  $package_ensure           = $zookeeper::params::package_ensure,
  $service_ensure           = $zookeeper::params::service_ensure,
  $service_enable           = $zookeeper::params::service_enable,
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
