# frozen_string_literal: true

module GitMarkdown
  module Models
    class Comment
      attr_reader :id, :body, :author, :path, :line, :html_url, :created_at, :updated_at, :in_reply_to_id

      def initialize(attrs = {})
        @id = attrs[:id]
        @body = attrs[:body] || ""
        @author = attrs[:author]
        @path = attrs[:path]
        @line = attrs[:line]
        @html_url = attrs[:html_url]
        @created_at = attrs[:created_at]
        @updated_at = attrs[:updated_at]
        @in_reply_to_id = attrs[:in_reply_to_id]
      end

      def self.from_api(data)
        new(
          id: data["id"],
          body: data["body"],
          author: data.dig("user", "login"),
          path: data["path"],
          line: data["line"] || data["original_line"],
          html_url: data["html_url"],
          created_at: data["created_at"],
          updated_at: data["updated_at"],
          in_reply_to_id: data["in_reply_to_id"]
        )
      end

      def inline?
        !@path.nil?
      end

      def reply?
        !@in_reply_to_id.nil?
      end
    end
  end
end
