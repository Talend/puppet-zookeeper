class zookeeper::install {

  tomcat::instance { 'ROOT':
    install_from_source => true,
    source_url          => $zookeeper::tomcat_source_url,
    catalina_base       => $zookeeper::catalina_base,
  } ->
  package {
    'zookeeper':
      ensure => installed;
    # https://github.com/Talend/tipaas-ops/blob/trunk/build_scripts/netflix-exhibitor/exhibitor-rpm.sh
    'netflix-exhibitor-tomcat':
      ensure => $::zookeeper::exhibitor_version;
  } ->
  file { '/opt/apache-tomcat/conf/context.xml':
    ensure => file,
    path   => '/opt/apache-tomcat/conf/context.xml',
    source => 'puppet:///modules/zookeeper/opt/apache-tomcat/conf/context.xml',
    mode   => '0600',
    owner  => 'tomcat',
    group  => 'tomcat'
  } ->
  file {
    '/etc/rc.d/init.d/zookeeper':
      ensure => absent;
    '/etc/init.d/zookeeper':
      ensure => absent;
  } ->
  exec { 'publishing exhibitor : 1':
    cwd     => $zookeeper::catalina_base,
    command => '/usr/bin/rm -rf webapps/docs webapps/examples \
    webapps/host-manager webapps/manager webapps/ROOT && /usr/bin/touch /tmp/exhibitor.1',
    creates => '/tmp/exhibitor.1'
  } ->
  exec { 'publishing exhibitor : 2':
    cwd     => $zookeeper::catalina_base,
    command => '/usr/bin/ln -s /opt/tomcat/webapps/exhibitor /opt/apache-tomcat/webapps/ROOT && /usr/bin/touch /tmp/exhibitor.2',
    creates => '/tmp/exhibitor.2'
  } ->
  exec { 'publishing exhibitor : 3':
    cwd     => $zookeeper::catalina_base,
    command => '/usr/bin/chown -R tomcat:tomcat /opt/tomcat && /usr/bin/touch /tmp/exhibitor.3',
    creates => '/tmp/exhibitor.3'
  }

  ensure_resource('file', '/home/tomcat', {
    'ensure' => 'directory',
    'owner'  => 'tomcat',
    'group'  => 'tomcat',
    'mode'   => '0700',
    'before' => Package['netflix-exhibitor-tomcat']
  })

}
