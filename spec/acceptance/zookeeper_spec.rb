require 'spec_helper'

describe 'zookeeper' do

  context 'When Exhibitor installed' do
    describe 'Tomcat Server Info' do
      subject { command('/usr/bin/java -cp /opt/apache-tomcat/lib/catalina.jar org.apache.catalina.util.ServerInfo') }
      its(:stdout) { should include 'Apache Tomcat/8.5.2' }
    end
    describe 'Tomcat Home Directory' do
       subject { file('/home/tomcat') }
       it { should be_directory }
       it { should be_owned_by 'tomcat' }
    end
  end

  describe command('/usr/bin/sleep 120') do
    its(:exit_status) { should eq 0 }
  end

  context 'When Exhibitor configured' do
    describe file('/etc/rc.d/init.d/zookeeper') do
      it { should_not exist }
    end

    describe file('/etc/init.d/zookeeper') do
      it { should_not exist }
    end

    describe command('/usr/bin/curl -v http://127.0.0.1:8080/exhibitor/v1/config/get-state') do
      its(:stdout) { should include '"clientPort":2181' }
      its(:stdout) { should include '"connectPort":2888' }
      its(:stdout) { should include '"electionPort":3888' }
    end
  end

  context 'When Exhibitor running' do
    describe port(8080) do
      it { should be_listening }
    end

    describe command('/usr/bin/wget -O - http://127.0.0.1:8080/exhibitor/v1/cluster/state') do
      its(:stdout) { should match /"description":"(serving|latent)"/ }
    end

    describe service('tomcat-exhibitor') do
      it { should be_running.under('systemd') }
    end
  end

  describe port(2181) do
    it { should be_listening }
  end

  describe command('echo ruok | /bin/nc 127.0.0.1 2181') do
    its(:stdout) { should eq 'imok' }
  end
end
