# frozen_string_literal: true

module GitMarkdown
  module Api
    class Response
      attr_reader :raw_response

      def initialize(response)
        @raw_response = response
      end

      def success?
        @raw_response.is_a?(Net::HTTPSuccess)
      end

      def not_found?
        @raw_response.is_a?(Net::HTTPNotFound)
      end

      def unauthorized?
        @raw_response.is_a?(Net::HTTPUnauthorized)
      end

      def data
        return nil unless @raw_response.body

        JSON.parse(@raw_response.body)
      rescue JSON::ParserError
        nil
      end

      def error_message
        return nil if success?

        if data && data["message"]
          data["message"]
        else
          "HTTP #{@raw_response.code}: #{@raw_response.message}"
        end
      end
    end
  end
end
