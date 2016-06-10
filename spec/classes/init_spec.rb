require 'spec_helper'
describe 'zookeeper' do

  let(:title) { 'zookeeper' }
  let(:node) { 'zookeeper.test.com' }

  describe 'building  on Centos' do
    let(:facts) { { :operatingsystem  => 'Centos',
                    :memorysize_mb    => 1024,
                    :concat_basedir   => '/var/lib/puppet/concat',
                    :osfamily         => 'RedHat',
                    :augeasversion    => '1.4.0',
                    :path             => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
                    :kernel           => 'Linux',
                    :architecture     => 'x86_64',
                    :ipaddress        => '192.168.0.1'
    }}


    context 'without params ' do

      # Test if it compiles
      it { should compile }
      it { should have_resource_count(5)}




      # Test all default params are set
      it {
        should contain_class('zookeeper')
        should contain_class('zookeeper::params')
        should contain_class('zookeeper::install').with_package_ensure('present')
        should contain_class('zookeeper::config')
        should contain_class('zookeeper::service')
      }

      it {
        should contain_package('zookeeper')
        should contain_package('exhibitor')
      }



    end

  end
end

