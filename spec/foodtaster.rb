module Foodtaster
  autoload :Client, 'foodtaster/client'
  autoload :RSpec,  'foodtaster/rspec'
  autoload :Vm,     'foodtaster/vm'

  def self.client
    @@client
  end

  def self.init(vagrant_server_url)
    @@client = Client.new(vagrant_server_url)
  end
end
