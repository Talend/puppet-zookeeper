require 'spec_helper'

describe 'zookeeper' do

  context 'When Zookeeper installed' do
    describe 'Tomcat Server Info' do
      subject { command('/usr/bin/java -cp /opt/apache-tomcat/lib/catalina.jar org.apache.catalina.util.ServerInfo') }
      its(:stdout) { should include 'Apache Tomcat/8.5.2' }
    end
  end

  describe port(2181) do
    it { should be_listening }
  end

  describe command('/usr/bin/wget -O - http://127.0.0.1:8080/exhibitor/v1/cluster/state') do
    its(:stdout) { should include '"description":"serving"' }
  end
end
