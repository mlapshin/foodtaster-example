module Foodtaster
  class Config
    attr_accessor :log_level
    attr_accessor :drb_port

    def initialize
      @log_level = :info
      @drb_port = 35672
      @vagrant_binary = 'vagrant'
    end

    def self.default
      self.new
    end
  end

  class << self
    def config
      @config ||= Config.default
    end

    def configure
      if block_given?
        yield(self.config)
      else
        raise ArgumentError, "No block given"
      end
    end
  end
end
