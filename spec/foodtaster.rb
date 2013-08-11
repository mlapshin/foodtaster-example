module Foodtaster
  autoload :Client, 'foodtaster/client'
  autoload :RSpec,  'foodtaster/rspec'
  autoload :Vm,     'foodtaster/vm'

  @@client = nil
  @@server_pid = nil

  def self.client
    @@client
  end

  def self.init(drb_port=35672)
    vagrant_binary = 'vagrant'
    at_exit { self.shutdown }

    # start vagrant server
    @@server_pid = Process.spawn("#{vagrant_binary} foodtaster-server #{drb_port.to_s}", pgroup: true)

    retry_count = 0
    begin
      sleep 0.2
      @@client = Client.new(drb_port)
    rescue DRb::DRbConnError
      retry_count += 1
      retry if retry_count < 10
    end

    if @@client.nil?
      puts "Cannot connect to Foodtaster DRb server."
      puts "Please run vagrant foodtaster-server manually and see it's output."
      exit -1
    end
  end

  def self.shutdown
    pgid = Process.getpgid(@@server_pid) rescue 0

    if pgid > 0
      puts "\n[FT] Stopping Foodtastic Server (PGID #{pgid})"

      Process.kill("INT", -pgid)
      Process.wait(-pgid)
    end
  end
end

# TODO: to separate file
RSpec::configure do |config|
  config.include Foodtaster::RSpec::ExampleMethods
  config.extend Foodtaster::RSpec::DslMethods

  config.before(:suite) do
    Foodtaster.init
    Foodtaster::RSpec.prepare_required_vms
  end

  config.after(:suite) do
    Foodtaster.shutdown
  end
end
