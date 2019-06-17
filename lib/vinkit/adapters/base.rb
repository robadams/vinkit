module Vinkit
  module Adapters
    class NotImplementedError < StandardError; end # adapter fails to implement method
    class InvalidError < StandardError; end # vin invalid
    class NotFoundError < StandardError; end # vin not found
    class Error < StandardError; end # everything else
    
    class Base 

      attr_reader :vin

      def initialize(vin) 
        @vin = vin
      end

      def year
        raise NotImplementedError, 'year method needs implemented'
      end

      def make
        raise NotImplementedError, 'make method needs implemented'
      end

      def model
        raise NotImplementedError, 'model method needs implemented'
      end
    end
  end
end
