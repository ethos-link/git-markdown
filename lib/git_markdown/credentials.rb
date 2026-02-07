# frozen_string_literal: true

module GitMarkdown
  class Credentials
    class << self
      def resolve(debug: false)
        token = from_env || from_git_credential || from_gh_cli || from_file

        raise AuthenticationError, "No GitHub token found. Run `git-markdown setup` to configure." if token.nil?

        token.strip
      rescue => e
        raise AuthenticationError, "Failed to resolve credentials: #{e.message}"
      end

      def from_env
        ENV["GITHUB_TOKEN"] || ENV["GH_TOKEN"]
      end

      def from_git_credential
        host = "github.com"
        protocol = "https"

        input = "protocol=#{protocol}\nhost=#{host}\n"
        output = nil
        env = {
          "GIT_TERMINAL_PROMPT" => "0",
          "GIT_ASKPASS" => "/bin/false",
          "SSH_ASKPASS" => "/bin/false"
        }

        IO.popen(env, %w[git credential fill], "r+") do |io|
          io.write(input)
          io.close_write
          output = io.read
        end

        return nil unless $?.success?

        output.each_line do |line|
          key, value = line.chomp.split("=", 2)
          return value if key == "password"
        end

        nil
      rescue
        nil
      end

      def from_gh_cli
        output = `gh auth token 2>/dev/null`
        output.strip if $?.success? && !output.strip.empty?
      rescue
        nil
      end

      def from_file
        credentials_file = File.join(
          Configuration::XDG_CONFIG_HOME,
          "git-markdown",
          "credentials"
        )

        return nil unless File.exist?(credentials_file)

        File.read(credentials_file).strip
      end
    end
  end
end
