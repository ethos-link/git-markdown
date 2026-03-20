# frozen_string_literal: true

module GitMarkdown
  module Providers
    class GitHub
      class Graphql
        RESOLVED_STATE_QUERY = <<~GRAPHQL
          query($owner: String!, $repo: String!, $number: Int!, $threadsAfter: String, $commentsAfter: String) {
            repository(owner: $owner, name: $repo) {
              pullRequest(number: $number) {
                reviewThreads(first: 100, after: $threadsAfter) {
                  pageInfo {
                    hasNextPage
                    endCursor
                  }
                  nodes {
                    isResolved
                    comments(first: 100, after: $commentsAfter) {
                      pageInfo {
                        hasNextPage
                        endCursor
                      }
                      nodes {
                        databaseId
                        body
                        path
                        line
                        createdAt
                        updatedAt
                        author {
                          login
                        }
                        replyTo {
                          databaseId
                        }
                        url
                      }
                    }
                  }
                }
              }
            }
          }
        GRAPHQL

        def initialize(config)
          @config = config
        end

        def fetch_resolved_states(owner, repo, number)
          resolved_ids = Set.new
          threads_after = nil

          loop do
            response = client.post("", {
              query: RESOLVED_STATE_QUERY,
              variables: {owner: owner, repo: repo, number: number,
                          threadsAfter: threads_after}
            })

            raise ApiError, "GraphQL request failed: #{response.error_message}" unless response.success?

            data = response.data
            threads_data = data.dig("data", "repository", "pullRequest", "reviewThreads")
            break unless threads_data

            threads_data["nodes"].each do |thread|
              next unless thread["isResolved"]

              thread["comments"]["nodes"].each do |comment|
                resolved_ids.add(comment["databaseId"]) if comment["databaseId"]
              end
            end

            threads_page = threads_data["pageInfo"]
            break unless threads_page["hasNextPage"]

            threads_after = threads_page["endCursor"]
          end

          resolved_ids
        end

        private

        def client
          @client ||= Api::Client.new(
            base_url: @config.graphql_url,
            token: @config.token
          )
        end
      end
    end
  end
end
