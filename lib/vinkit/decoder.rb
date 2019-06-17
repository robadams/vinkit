module Vinkit
  class Decoder
    attr_reader :vin

    def initialize(vin, options = {})
      @vin = vin

      adapter_class = options.fetch(:adapter) { Vinkit::DEFAULT_ADAPTER }
      @adapter = adapter_class.new(vin)
    end

    def year
      adapter.year
    end

    def make
      adapter.make
    end

    def model
      adapter.model
    end

    private 

    attr_reader :adapter
  end
end
