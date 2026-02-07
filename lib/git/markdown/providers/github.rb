# frozen_string_literal: true

module GitMarkdown
  module Providers
    class GitHub < Base
      def fetch_pull_request(owner, repo, number)
        path = "/repos/#{owner}/#{repo}/pulls/#{number}"
        response = client.get(path)

        raise NotFoundError, "Pull request #{owner}/#{repo}##{number} not found" if response.not_found?
        raise ApiError, "Failed to fetch PR: #{response.error_message}" unless response.success?

        Models::PullRequest.from_api(response.data)
      end

      def fetch_comments(owner, repo, number)
        path = "/repos/#{owner}/#{repo}/issues/#{number}/comments"
        comments = fetch_all_pages(path)

        comments.map { |data| Models::Comment.from_api(data) }
      end

      def fetch_reviews(owner, repo, number)
        path = "/repos/#{owner}/#{repo}/pulls/#{number}/reviews"
        reviews = fetch_all_pages(path)

        reviews.map do |review_data|
          review = Models::Review.from_api(review_data)
          review.comments = fetch_review_comments(owner, repo, review.id)
          review
        end
      end

      def fetch_review_comments(owner, repo, review_id)
        path = "/repos/#{owner}/#{repo}/pulls/comments"
        all_comments = fetch_all_pages(path)

        all_comments
          .select { |c| c["pull_request_review_id"] == review_id }
          .map { |data| Models::Comment.from_api(data) }
      end

      private

      def client
        @client ||= Api::Client.new(
          base_url: @config.api_url,
          token: @config.token
        )
      end

      def fetch_all_pages(path, params = {})
        results = []
        page = 1
        per_page = 100

        loop do
          response = client.get(path, params.merge(page: page, per_page: per_page))
          break unless response.success?

          data = response.data
          break if data.empty?

          results.concat(data)
          break if data.length < per_page

          page += 1
        end

        results
      end
    end
  end
end
