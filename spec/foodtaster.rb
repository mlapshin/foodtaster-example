require 'foodtaster/config'
require 'logger'

module Foodtaster
  autoload :Client, 'foodtaster/client'
  autoload :RSpec,  'foodtaster/rspec'
  autoload :Vm,     'foodtaster/vm'
  autoload :RSpecRun, 'foodtaster/rspec_run'

  class << self
    def logger
      @logger ||= Logger.new(STDOUT).tap do |log|
        log.level = Logger.const_get(self.config.log_level.to_s.upcase)
        log.formatter = proc do |severity, datetime, progname, msg|
          "[FT #{severity}]: #{msg}\n"
        end
      end
    end
  end
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
