require 'set'

module Foodtaster
  class RSpecRun
    def initialize
      @required_vm_names = Set.new
      @client = nil
      @server_pid = nil
    end

    def require_vm(vm_name)
      @required_vm_names.add(vm_name.to_sym)
    end

    def required_vm_names
      @required_vm_names
    end

    def get_vm(vm_name)
      Foodtaster::Vm.new(vm_name, @client)
    end

    def start
      at_exit { self.stop }

      start_server_and_connect_client
      prepare_required_vms
    end

    def stop
      terminate_server
    end

    def client
      @client
    end

    class << self
      @instance = nil

      def current
        @instance ||= self.new
      end
    end

    private

    def prepare_required_vms
      self.required_vm_names.each { |vm_name| get_vm(vm_name).prepare }
    end

    def start_server_and_connect_client(drb_port=35672)
      vagrant_binary = 'vagrant'

      # start vagrant server
      @server_pid = Process.spawn("#{vagrant_binary} foodtaster-server #{drb_port.to_s}", pgroup: true)

      connect_client(drb_port)
    end

    def connect_client(drb_port)
      retry_count = 0
      begin
        sleep 0.2
        @client = Foodtaster::Client.new(drb_port)
      rescue DRb::DRbConnError
        retry_count += 1
        retry if retry_count < 10
      end

      if @client.nil?
        puts "Cannot start or connect to Foodtaster DRb server."
        puts "Please run 'vagrant foodtaster-server' command manually and see it's output."
        exit -1
      end
    end

    def terminate_server
      pgid = Process.getpgid(@server_pid) rescue 0

      if pgid > 0
        puts "\n[FT] Stopping Foodtastic Server (PGID #{pgid})"

        Process.kill("INT", -pgid)
        Process.wait(-pgid)
      end
    end
  end
end
