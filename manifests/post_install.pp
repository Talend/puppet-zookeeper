# post install steps
  
class zookeeper::post_install {

  require ::zookeeper::service

  $myid= $::cfn_resource_name ? {
    InstanceA => '1',
    InstanceB => '2',
    InstanceC => '3',
    undef     => 'No Value'
  }
  file {
    '/var/lib/zookeeper/data/myid':
      ensure  => file,
      content => $myid,
      owner   => $zookeeper::zookeeper_user,
      group   => $zookeeper::zookeeper_user_group,
      require => [
        Service['tomcat-exhibitor']
      ]
  }
}
