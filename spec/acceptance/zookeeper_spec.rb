require 'spec_helper_acceptance'

describe 'zookeeper' do

  it 'installs without errors' do
    pp = <<-EOS

    class {'java':}

    include ::packagecloud

    packagecloud::repo {'talend/other':
      type         => 'rpm',
      master_token => #{ENV['PACKAGECLOUD_MASTER_TOKEN']}
    }


    class {'::zookeeper': }

    EOS

    apply_manifest(pp, :catch_failures => true)
  end


end

