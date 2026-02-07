# frozen_string_literal: true

module GitMarkdown
  class CLI < Thor
    class_option :debug, type: :boolean, default: false, desc: "Enable verbose debug output"

    desc "setup", "Configure git-markdown with your GitHub token"
    def setup
      puts "git-markdown setup"
      puts "=================="
      puts
      puts "This will store your GitHub token in ~/.config/git-markdown/credentials"
      puts
      puts "To create a token, visit:"
      puts "  GitHub: https://github.com/settings/personal-access-tokens"
      puts "  (For GitLab: https://gitlab.com/-/profile/personal_access_tokens)"
      puts
      puts "Required permissions/scopes:"
      puts "  - repo (for private repositories)"
      puts "  - read:org (for organization repositories)"
      puts "  - read:discussion (for PR discussions)"
      puts
      print "Enter your GitHub Personal Access Token: "
      token = $stdin.noecho(&:gets).chomp
      puts

      if token.nil? || token.strip.empty?
        puts "Error: Token cannot be empty"
        exit 1
      end

      config = Configuration.new
      config.save_credentials!(token)
      config.save!

      puts "✓ Credentials saved successfully"
      puts "✓ Configuration saved to #{config.config_file}"
    rescue => e
      puts "Error: #{e.message}"
      exit 1
    end

    desc "pr PR_IDENTIFIER", "Fetch a pull request and convert to Markdown"
    option :output, type: :string, desc: "Output directory or file path"
    option :stdout, type: :boolean, default: false, desc: "Output to stdout instead of file", lazy_default: true
    option :status, type: :string, default: "unresolved", enum: %w[unresolved resolved all],
      desc: "Filter comments by status"
    def pr(identifier)
      config = Configuration.load
      owner, repo, number = parse_identifier(identifier)

      debug_log(options[:debug], "Fetching PR #{owner}/#{repo}##{number}")
      debug_log(options[:debug], "API URL: #{config.api_url}")

      provider = create_provider(config)

      puts "Fetching pull request..." unless options[:stdout]
      pull_request = provider.fetch_pull_request(owner, repo, number)
      debug_log(options[:debug], "PR title: #{pull_request.title}")

      puts "Fetching comments..." unless options[:stdout]
      comments = provider.fetch_comments(owner, repo, number)
      debug_log(options[:debug], "Found #{comments.length} general comments")

      puts "Fetching reviews..." unless options[:stdout]
      reviews = provider.fetch_reviews(owner, repo, number)
      debug_log(options[:debug], "Found #{reviews.length} reviews")

      generator = Markdown::Generator.new(
        pull_request,
        comments,
        reviews,
        status_filter: options[:status].to_sym
      )

      markdown = generator.generate

      if options[:stdout]
        puts markdown
      else
        output_path = determine_output_path(options[:output], generator.filename)
        File.write(output_path, markdown)
        puts "✓ Saved to #{output_path}"
      end
    rescue AuthenticationError => e
      puts "Authentication error: #{e.message}"
      exit 1
    rescue NotFoundError => e
      puts "Not found: #{e.message}"
      exit 1
    rescue ApiError => e
      puts "API error: #{e.message}"
      debug_log(options[:debug], e.backtrace.join("\n"))
      exit 1
    rescue => e
      puts "Error: #{e.message}"
      debug_log(options[:debug], e.backtrace.join("\n"))
      exit 1
    end

    desc "version", "Show version"
    def version
      puts GitMarkdown::VERSION
    end

    default_task :help

    private

    def parse_identifier(identifier)
      if identifier.include?("#")
        parts = identifier.split("#")
        repo_parts = parts[0].split("/")
        raise Error, "Invalid format. Use: owner/repo#123 or just 123" unless repo_parts.length == 2

        [repo_parts[0], repo_parts[1], parts[1].to_i]

      else
        remote = RemoteParser.from_git_remote
        if remote.nil? || !remote.valid?
          raise Error, "Cannot detect repository from git remote. Use owner/repo#123 format."
        end

        [remote.owner, remote.repo, identifier.to_i]
      end
    end

    def create_provider(config)
      case config.provider
      when :github
        Providers::GitHub.new(config)
      else
        raise Error, "Unsupported provider: #{config.provider}"
      end
    end

    def determine_output_path(output_option, filename)
      if output_option.nil?
        File.join(Dir.pwd, filename)
      elsif File.directory?(output_option)
        File.join(output_option, filename)
      else
        output_option
      end
    end

    def debug_log(debug, message)
      return unless debug

      warn "[DEBUG] #{message}"
    end
  end
end
