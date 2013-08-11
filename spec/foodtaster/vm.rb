module Foodtaster
  class Vm
    class ChefRunConfig
      attr_accessor :json, :recipes

      def initialize(vm)
        @vm = vm
        @json = {}
        @recipes = []
      end

      def add_recipe(recipe_name)
        @recipes << recipe_name
      end

      def to_hash
        {
          json: @json,
          recipes: @recipes
        }
      end
    end

    class ExecResult
      attr_reader :stderr
      attr_reader :stdout
      attr_reader :exit_status

      def initialize(hash)
        @stderr = hash[:stderr]
        @stdout = hash[:stdout]
        @exit_status = hash[:exit_status]
      end

      def successful?
        exit_status == 0
      end
    end

    attr_reader :name

    def initialize(name)
      @name = name
      @client = Foodtaster.client

      unless @client.vm_defined?(name)
        raise "No machine defined with name #{name}"
      end
    end

    def prepare
      @client.prepare_vm(name)
    end

    def rollback
      @client.rollback_vm(name)
    end

    def execute(command)
      puts "[FT] Execute on #{name}: #{command}"
      exec_result_hash = @client.execute_on_vm(name, command)

      ExecResult.new(exec_result_hash)
    end

    def run_chef(&conf_block)
      config = ChefRunConfig.new(self)
      conf_block.call(config)

      @client.run_chef_on_vm(name, config.to_hash)
    end
  end
end
