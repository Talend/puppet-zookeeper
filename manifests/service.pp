class zookeeper::service (

  $catalina_base  = $zookeeper::exhibitor_catalina_base,

){

  tomcat::service { 'exhibitor':
    catalina_base => $catalina_base,
    use_init      => false,
  } ->
  exec { 'waiting for exhibitor to start':
    command => '/usr/bin/wget --spider --tries 15 --retry-connrefused http://localhost:8080/exhibitor/exhibitor/v1/config/get-state'
  } ->
  exec { 'update the config':
    command => '/usr/bin/curl -X POST -d \'{"logIndexDirectory":"","zookeeperInstallDirectory":"/usr/lib/zookeeper","zookeeperDataDirectory":"/var/lib/zookeeper/data","zookeeperLogDirectory":"","serversSpec":"","backupExtra":"","zooCfgExtra":{"syncLimit":"5","tickTime":"2000","initLimit":"10"},"javaEnvironment":"","log4jProperties":"","clientPort":2181,"connectPort":2888,"electionPort":3888,"checkMs":30000,"cleanupPeriodMs":43200000,"cleanupMaxFiles":3,"backupMaxStoreMs":86400000,"backupPeriodMs":60000,"autoManageInstances":0,"autoManageInstancesSettlingPeriodMs":180000,"observerThreshold":999,"autoManageInstancesFixedEnsembleSize":0,"autoManageInstancesApplyAllAtOnce":1,"controlPanel":{}}\' http://localhost:8080/exhibitor/exhibitor/v1/config/set'
  } ->
  exec { 'wait till exhibitor starts zookeeper':
    command => '/usr/bin/sleep 30'
  }

}
