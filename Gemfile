source 'http://rubygems.org'

gem 'puppet', '~> 3.8'
gem 'librarian-puppet', '~> 3.0'
gem 'rake'
gem 'kitchen-ec2', '1.3.2'

group :test do
  gem 'metadata-json-lint'
  gem 'puppetlabs_spec_helper'
end

group :development do
  gem 'vagrant-wrapper'
  gem 'kitchen-vagrant'
end

group :system_tests do
  gem 'test-kitchen'
  gem 'kitchen-puppet'
  gem 'kitchen-sync'
  gem 'kitchen-verifier-serverspec'
  gem 'net-ssh'
  gem 'serverspec'
  gem 'rspec_junit_formatter'
end
