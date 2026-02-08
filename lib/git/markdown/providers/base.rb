# frozen_string_literal: true

module GitMarkdown
  module Providers
    class Base
      attr_reader :config

      def initialize(config)
        @config = config
      end

      def fetch_pull_request(owner, repo, number)
        raise NotImplementedError
      end

      def fetch_comments(owner, repo, number)
        raise NotImplementedError
      end

      def fetch_reviews(owner, repo, number)
        raise NotImplementedError
      end

      def fetch_review_comments(owner, repo, review_id)
        raise NotImplementedError
      end
    end
  end
end
