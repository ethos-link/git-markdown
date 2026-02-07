# frozen_string_literal: true

module GitMarkdown
  class RemoteParser
    PATTERNS = {
      github: %r{(?:github\.com|github\.enterprise)[/:]([^/]+)/([^/]+?)(?:\.git)?$},
      gitlab: %r{gitlab\.com[/:]([^/]+)/([^/]+?)(?:\.git)?$}
    }

    attr_reader :url, :provider, :owner, :repo

    def initialize(url)
      @url = url
      parse!
    end

    def self.parse(url)
      new(url)
    end

    def self.from_git_remote(remote = "origin")
      url = git_remote_url(remote)
      return nil if url.nil? || url.empty?

      new(url)
    end

    def valid?
      !@provider.nil?
    end

    def full_name
      "#{@owner}/#{@repo}" if valid?
    end

    private

    def parse!
      PATTERNS.each do |provider_name, pattern|
        next unless (match = @url.match(pattern))

        @provider = provider_name
        @owner = match[1]
        @repo = match[2]
        break
      end
    end

    private_class_method def self.git_remote_url(remote)
      output = `git remote get-url #{remote} 2>/dev/null`
      output.strip if $?.success?
    end
  end
end
