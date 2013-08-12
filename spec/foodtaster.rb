module Foodtaster
  autoload :Client, 'foodtaster/client'
  autoload :RSpec,  'foodtaster/rspec'
  autoload :Vm,     'foodtaster/vm'
  autoload :RSpecRun, 'foodtaster/rspec_run'
end

# TODO: to separate file
RSpec::configure do |config|
  config.include Foodtaster::RSpec::ExampleMethods
  config.extend Foodtaster::RSpec::DslMethods

  config.before(:suite) do
    Foodtaster::RSpecRun.current.start
  end

  config.after(:suite) do
    Foodtaster::RSpecRun.current.stop
  end
end
