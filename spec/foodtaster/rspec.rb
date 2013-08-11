module Foodtaster
  module RSpec
    module ExampleMethods
      def get_vm(vm_name)
        Foodtaster::RSpec.get_vm(vm_name)
      end

      def run_chef_on(vm_name, &block)
        Foodtaster::Rspec.run_chef_on(vm_name, &block)
      end
    end

    module DslMethods
      def run_chef_on(vm_name, &block)
        Foodtaster::RSpec.require_vm(vm_name)
        vm = Foodtaster::RSpec.get_vm(vm_name)
        skip_rollback = true

        before(:all) do
          vm.rollback unless skip_rollback
          vm.run_chef(&block)
        end

        let(vm_name) { vm }
      end
    end

    class << self
      @@required_vm_names = Set.new

      def require_vm(vm_name)
        @@required_vm_names.add(vm_name)
      end

      def required_vm_names
        @@required_vm_names
      end

      def get_vm(vm_name)
        Foodtaster::Vm.new(vm_name)
      end

      def prepare_required_vms
        self.required_vm_names.each { |vm_name| get_vm(vm_name).prepare }
      end

      def run_chef_on(vm_name, &block)
        vm = get_vm(vm_name)
        vm.run_chef_on(&block)
      end
    end
  end
end

Dir[File.dirname(__FILE__) + "/matchers/*.rb"].each do |f|
  require f
end

RSpec::Matchers.send(:include, Foodtaster::RSpec::Matchers::MatcherMethods)
