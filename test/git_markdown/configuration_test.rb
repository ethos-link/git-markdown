# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @test_config_dir = setup_test_config
    @old_github_token = ENV["GITHUB_TOKEN"]
    ENV.delete("GITHUB_TOKEN")
  end

  def teardown
    teardown_test_config
    ENV["GITHUB_TOKEN"] = @old_github_token
  end

  def test_default_values
    config = GitMarkdown::Configuration.new

    assert_equal :github, config.provider
    assert_equal Dir.pwd, config.output_dir
    assert_equal :unresolved, config.default_status
  end

  def test_config_dir_uses_xdg
    config = GitMarkdown::Configuration.new
    expected = File.join(@test_config_dir, "git-markdown")

    assert_equal expected, config.config_dir
  end

  def test_save_creates_config_file
    config = GitMarkdown::Configuration.new
    config.save!

    assert File.exist?(config.config_file)
  end

  def test_save_creates_directory
    config = GitMarkdown::Configuration.new
    config.save!

    assert File.directory?(config.config_dir)
  end

  def test_save_credentials_creates_file
    config = GitMarkdown::Configuration.new
    config.save_credentials!("test_token")

    assert File.exist?(config.credentials_file)
    assert_equal "test_token", File.read(config.credentials_file)
  end

  def test_save_credentials_sets_permissions
    skip unless RUBY_PLATFORM.include?("linux") || RUBY_PLATFORM.include?("darwin")

    config = GitMarkdown::Configuration.new
    config.save_credentials!("test_token")

    mode = File.stat(config.credentials_file).mode & 0o777
    assert_equal 0o600, mode
  end

  def test_load_from_file
    ENV["GITHUB_TOKEN"] = "test_token"

    config = GitMarkdown::Configuration.new
    config.provider = :gitlab
    config.save!

    loaded = GitMarkdown::Configuration.load
    assert_equal :gitlab, loaded.provider
  end

  def test_resolve_credentials_uses_env
    ENV["GITHUB_TOKEN"] = "env_token"

    config = GitMarkdown::Configuration.new
    config.load!

    assert_equal "env_token", config.token
  end

  def test_resolve_api_url_uses_env
    ENV["GITHUB_TOKEN"] = "test_token"
    ENV["GITHUB_API_URL"] = "https://enterprise.github.com/api/v3"

    config = GitMarkdown::Configuration.new
    config.load!

    assert_equal "https://enterprise.github.com/api/v3", config.api_url
  end

  def test_resolve_api_url_defaults_to_github
    ENV["GITHUB_TOKEN"] = "test_token"
    ENV.delete("GITHUB_API_URL")

    config = GitMarkdown::Configuration.new
    config.load!

    assert_equal "https://api.github.com", config.api_url
  end
end
