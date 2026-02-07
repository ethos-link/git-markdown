# frozen_string_literal: true

module GitMarkdown
  module Api
    class Client
      def initialize(base_url:, token:)
        @base_url = base_url
        @token = token
      end

      def get(path, params = {})
        uri = build_uri(path, params)
        request = Net::HTTP::Get.new(uri)
        set_headers(request)

        response = http_request(uri, request)
        Response.new(response)
      end

      private

      def build_uri(path, params)
        uri = URI.parse("#{@base_url}#{path}")
        uri.query = URI.encode_www_form(params) unless params.empty?
        uri
      end

      def set_headers(request)
        request["Authorization"] = "Bearer #{@token}"
        request["Accept"] = "application/vnd.github.v3+json"
        request["User-Agent"] = "git-markdown/#{GitMarkdown::VERSION}"
      end

      def http_request(uri, request)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = uri.scheme == "https"
        http.open_timeout = 10
        http.read_timeout = 30

        http.request(request)
      rescue Net::OpenTimeout, Net::ReadTimeout => e
        raise ApiError, "Request timeout: #{e.message}"
      rescue => e
        raise ApiError, "Request failed: #{e.message}"
      end
    end
  end
end
