# frozen_string_literal: true

require "io/console"
require "json"
require "net/http"
require "uri"
require "erb"
require "fileutils"

require "thor"

require_relative "git_markdown/version"
require_relative "git_markdown/configuration"
require_relative "git_markdown/credentials"
require_relative "git_markdown/remote_parser"
require_relative "git_markdown/providers/base"
require_relative "git_markdown/providers/github"
require_relative "git_markdown/api/client"
require_relative "git_markdown/api/response"
require_relative "git_markdown/models/pull_request"
require_relative "git_markdown/models/comment"
require_relative "git_markdown/models/review"
require_relative "git_markdown/markdown/generator"
require_relative "git_markdown/cli"

module GitMarkdown
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class NotFoundError < Error; end

  class ApiError < Error; end
end
