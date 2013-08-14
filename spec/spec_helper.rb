require 'rspec'
require 'foodtaster'

RSpec.configure do |config|
  config.color_enabled = true
end

Foodtaster.configure do |config|
  config.log_level = :debug
end
