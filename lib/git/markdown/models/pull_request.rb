# frozen_string_literal: true

module GitMarkdown
  module Models
    class PullRequest
      attr_reader :number, :title, :body, :state, :author, :html_url, :created_at, :updated_at

      def initialize(attrs = {})
        @number = attrs[:number]
        @title = attrs[:title]
        @body = attrs[:body] || ""
        @state = attrs[:state]
        @author = attrs[:author]
        @html_url = attrs[:html_url]
        @created_at = attrs[:created_at]
        @updated_at = attrs[:updated_at]
      end

      def self.from_api(data)
        new(
          number: data["number"],
          title: data["title"],
          body: data["body"],
          state: data["state"],
          author: data.dig("user", "login"),
          html_url: data["html_url"],
          created_at: data["created_at"],
          updated_at: data["updated_at"]
        )
      end

      def open?
        @state == "open"
      end

      def closed?
        @state == "closed"
      end
    end
  end
end
