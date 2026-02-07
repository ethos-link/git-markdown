# frozen_string_literal: true

module GitMarkdown
  class Configuration
    XDG_CONFIG_HOME = ENV.fetch("XDG_CONFIG_HOME", File.expand_path("~/.config"))
    DEFAULT_PROVIDER = :github

    attr_accessor :token, :provider, :api_url, :output_dir, :default_status

    def initialize
      @provider = DEFAULT_PROVIDER
      @output_dir = Dir.pwd
      @default_status = :unresolved
      @api_url = nil
    end

    def self.load
      new.load!
    end

    def load!
      load_from_file if config_file_exist?
      resolve_credentials
      resolve_api_url if api_url.nil?
      self
    end

    def config_dir
      File.join(XDG_CONFIG_HOME, "git-markdown")
    end

    def config_file
      File.join(config_dir, "config.yml")
    end

    def credentials_file
      File.join(config_dir, "credentials")
    end

    def save!
      FileUtils.mkdir_p(config_dir)
      File.write(config_file, config_to_yaml)
      FileUtils.chmod(0o700, config_dir)
    end

    def save_credentials!(token_value)
      FileUtils.mkdir_p(config_dir)
      File.write(credentials_file, token_value)
      FileUtils.chmod(0o600, credentials_file)
      @token = token_value
    end

    private

    def config_file_exist?
      File.exist?(config_file)
    end

    def load_from_file
      require "yaml"
      config = YAML.safe_load_file(
        config_file,
        symbolize_names: true,
        permitted_classes: [Symbol]
      )
      @provider = config[:provider] if config[:provider]
      @api_url = config[:api_url] if config[:api_url]
      @output_dir = config[:output_dir] if config[:output_dir]
      @default_status = config[:default_status].to_sym if config[:default_status]
    end

    def resolve_credentials
      @token ||= Credentials.resolve(debug: false)
    end

    def resolve_api_url
      @api_url = ENV.fetch("GITHUB_API_URL") do
        (@provider == :github) ? "https://api.github.com" : nil
      end
    end

    def config_to_yaml
      {
        provider: @provider,
        api_url: @api_url,
        output_dir: @output_dir,
        default_status: @default_status
      }.to_yaml
    end
  end
end
