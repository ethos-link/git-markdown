# frozen_string_literal: true

module GitMarkdown
  module Models
    class Review
      attr_reader :id, :state, :body, :author, :html_url, :submitted_at
      attr_accessor :comments

      def initialize(attrs = {})
        @id = attrs[:id]
        @state = attrs[:state]
        @body = attrs[:body] || ""
        @author = attrs[:author]
        @html_url = attrs[:html_url]
        @submitted_at = attrs[:submitted_at]
        @comments = attrs[:comments] || []
      end

      def self.from_api(data)
        new(
          id: data["id"],
          state: data["state"],
          body: data["body"],
          author: data.dig("user", "login"),
          html_url: data["html_url"],
          submitted_at: data["submitted_at"]
        )
      end

      def approved?
        @state == "APPROVED"
      end

      def changes_requested?
        @state == "CHANGES_REQUESTED"
      end

      def commented?
        @state == "COMMENTED"
      end

      def dismissed?
        @state == "DISMISSED"
      end
    end
  end
end
