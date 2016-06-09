require 'spec_helper'
describe 'zookeeper' do

  context 'with default values for all parameters' do
    it { should contain_class('zookeeper') }
  end
end
