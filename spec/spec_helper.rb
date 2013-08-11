require 'rspec'
require 'foodtaster'

Foodtaster.init

RSpec.configure do |config|
  config.include Foodtaster::RSpec::ExampleMethods
  config.extend Foodtaster::RSpec::DslMethods

  config.color_enabled = true

  config.before(:suite) do
    Foodtaster::RSpec.prepare_required_vms
  end
end
