require "faraday"

module Vinkit
  module Adapters
    class Nhtsa < Base # https://vpic.nhtsa.dot.gov/decoder/Decoder
      API_URL = 'https://vpic.nhtsa.dot.gov/api/vehicles/decodevinvalues/{vin}?format=json'

      def year
        fetch("ModelYear")
      end

      def make
        fetch("Make")
      end

      def model
        fetch("Model")
      end

      private

      def fetch(key)
        target
          .fetch(key)
          .split
          .map(&:capitalize)
          .join(' ')
      end

      def target
        @_target ||= payload.fetch("Results").first
      end

      def payload
        return if @_payload 

        payload = JSON.parse(response.body)

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
