require "faraday"

module Vinkit
  module Adapters
    class Nhtsa < Base # https://vpic.nhtsa.dot.gov/decoder/Decoder
      API_URL = 'https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/{vin}?format=json'.freeze

      def year
        fetch("ModelYear")
      end

      def make
        fetch("Make")
      end

      def model
        fetch("Model")
      end

      def error?
      end

      private

      def fetch(key)
        payload
          .fetch(key)
          .split
          .map(&:capitalize)
          .join(' ')
      end

      def payload
        return if @_payload 

        begin
          payload = JSON.parse(response.body)
          payload = payload.fetch("Results").first
        rescue => e
          raise Vinkit::Adapters::Error, e.message # most likely parse errror or change in response format
        end

        error_code = payload.fetch("ErrorCode")
        unless error_code.match(/0 - VIN decoded clean/)
          raise Vinkit::Adapters::Error, "Error decoding vin: #{error_code}" # refer to error code
        end

        @_payload = payload
      end

      def response
        return if @_response

        response = Faraday.get(url)
        if response.status == 200
          @_response = response
        else
          raise Vinkit::Adapters::Error, "Invalid response status from Nhtsa adapter: #{response.status}"
        end 
      end

      def url
        @_url ||= API_URL.gsub(/{vin}/, vin)
      end
    end
  end
end
