require 'rspec'
require 'foodtaster'

RSpec.configure do |config|
  config.color_enabled = true

  config.before(:suite) do
    `berks install --path #{File.dirname(__FILE__)}/../cookbooks`
  end
end

Foodtaster.configure do |config|
  config.drb_port = 33033
  config.skip_rollback = !ENV["SKIP_ROLLBACK"].nil?
  config.vagrant_binary = "/opt/vagrant/bin/vagrant"
end
