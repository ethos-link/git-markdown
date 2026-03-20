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
        resolved_ids = fetch_resolved_comment_ids(owner, repo, number)

        path = "/repos/#{owner}/#{repo}/pulls/#{number}/reviews"
        reviews = fetch_all_pages(path)

        all_pr_comments = fetch_all_pr_comments(owner, repo, number)

        reviews.map do |review_data|
          review = Models::Review.from_api(review_data)
          review.comments = all_pr_comments
            .select { |c| c["pull_request_review_id"] == review.id }
            .map do |data|
              comment = Models::Comment.from_api(data)
              comment.resolved = resolved_ids.include?(comment.id)
              comment
          end
          review
        end
      end

      def fetch_review_comments(owner, repo, review_id, resolved_ids = Set.new)
        all_pr_comments = fetch_all_pr_comments(owner, repo)

        all_pr_comments
          .select { |c| c["pull_request_review_id"] == review_id }
          .map do |data|
            comment = Models::Comment.from_api(data)
            comment.resolved = resolved_ids.include?(comment.id)
            comment
          end
      end

      private

      def client
        @client ||= Api::Client.new(
          base_url: @config.api_url,
          token: @config.token
        )
      end

      def graphql_client
        @graphql_client ||= Graphql.new(@config)
      end

      def fetch_resolved_comment_ids(owner, repo, number)
        graphql_client.fetch_resolved_states(owner, repo, number)
      rescue ApiError
        Set.new
      end

      def fetch_all_pr_comments(owner, repo, _number = nil)
        @all_pr_comments ||= {}
        key = "#{owner}/#{repo}"
        @all_pr_comments[key] ||= fetch_all_pages("/repos/#{owner}/#{repo}/pulls/comments")
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
