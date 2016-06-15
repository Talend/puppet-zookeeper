require 'spec_helper'

describe 'zookeeper' do
  describe command('/usr/bin/wget -O - http://127.0.0.1:8080/exhibitor/exhibitor/v1/cluster/state') do
    its(:stdout) { should include '"description":"serving"' }
  end
end
