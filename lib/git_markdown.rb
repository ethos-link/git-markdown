# frozen_string_literal: true

require "io/console"
require "json"
require "net/http"
require "uri"
require "erb"
require "fileutils"

require "thor"

require_relative "git/markdown/version"
require_relative "git/markdown/configuration"
require_relative "git/markdown/credentials"
require_relative "git/markdown/remote_parser"
require_relative "git/markdown/providers/base"
require_relative "git/markdown/providers/github"
require_relative "git/markdown/api/client"
require_relative "git/markdown/api/response"
require_relative "git/markdown/models/pull_request"
require_relative "git/markdown/models/comment"
require_relative "git/markdown/models/review"
require_relative "git/markdown/markdown/generator"
require_relative "git/markdown/cli"

module GitMarkdown
  class Error < StandardError; end

  class AuthenticationError < Error; end

  class NotFoundError < Error; end

  class ApiError < Error; end
end
