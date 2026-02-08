# frozen_string_literal: true

module GitMarkdown
  module Markdown
    class Generator
      def initialize(pull_request, comments, reviews, status_filter: :unresolved)
        @pr = pull_request
        @comments = comments
        @reviews = reviews
        @status_filter = status_filter
      end

      def generate
        template = File.read(template_path)
        erb = ERB.new(template, trim_mode: "-")
        erb.result(binding)
      end

      def filename
        title_slug = @pr.title.downcase.gsub(/[^a-z0-9]+/, "-").gsub(/^-|-$/, "")
        "PR-#{@pr.number}-#{title_slug}.md"
      end

      private

      def template_path
        File.join(__dir__, "templates", "default.erb")
      end

      def format_date(date_string)
        return nil unless date_string

        Time.parse(date_string).strftime("%Y-%m-%d %H:%M UTC")
      rescue
        date_string
      end

      def filtered_inline_comments
        @reviews.flat_map(&:comments).select do |comment|
          include_comment?(comment)
        end
      end

      def filtered_general_comments
        @comments.select do |comment|
          include_comment?(comment)
        end
      end

      def include_comment?(comment)
        case @status_filter
        when :unresolved
          !comment.body.include?("[resolved]") && !comment.body.include?("[done]")
        when :resolved
          comment.body.include?("[resolved]") || comment.body.include?("[done]")
        else
          true
        end
      end

      def group_comments_by_file(comments)
        comments.select(&:inline?).group_by(&:path)
      end
    end
  end
end
