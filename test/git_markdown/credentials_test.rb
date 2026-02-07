# frozen_string_literal: true

require "test_helper"

class CredentialsTest < Minitest::Test
  def setup
    @test_config_dir = setup_test_config
  end

  def teardown
    teardown_test_config
  end

  def test_from_env_returns_github_token
    with_env("GITHUB_TOKEN", "test_token_123") do
      assert_equal "test_token_123", GitMarkdown::Credentials.from_env
    end
  end

  def test_from_env_returns_gh_token
    with_env("GH_TOKEN", "gh_token_456") do
      assert_equal "gh_token_456", GitMarkdown::Credentials.from_env
    end
  end

  def test_from_env_prefers_github_token
    with_env("GITHUB_TOKEN", "github_token") do
      with_env("GH_TOKEN", "gh_token") do
        assert_equal "github_token", GitMarkdown::Credentials.from_env
      end
    end
  end

  def test_from_env_returns_nil_when_no_token
    without_env(%w[GITHUB_TOKEN GH_TOKEN]) do
      assert_nil GitMarkdown::Credentials.from_env
    end
  end

  def test_from_file_returns_token
    credentials_file = File.join(@test_config_dir, "git-markdown", "credentials")
    FileUtils.mkdir_p(File.dirname(credentials_file))
    File.write(credentials_file, "file_token_789")

    assert_equal "file_token_789", GitMarkdown::Credentials.from_file
  end

  def test_from_file_returns_nil_when_file_missing
    assert_nil GitMarkdown::Credentials.from_file
  end

  def test_resolve_raises_when_no_credentials
    skip "This test requires mocking system calls"

    without_env(%w[GITHUB_TOKEN GH_TOKEN]) do
      assert_raises(GitMarkdown::AuthenticationError) do
        GitMarkdown::Credentials.resolve
      end
    end
  end

  def test_resolve_prefers_env
    with_env("GITHUB_TOKEN", "env_token") do
      assert_equal "env_token", GitMarkdown::Credentials.resolve
    end
  end

  private

  def with_env(key, value)
    old_value = ENV[key]
    ENV[key] = value
    yield
  ensure
    ENV[key] = old_value
  end

  def without_env(keys)
    old_values = keys.map { |k| [k, ENV[k]] }
    keys.each { |k| ENV.delete(k) }
    yield
  ensure
    old_values.each { |k, v| ENV[k] = v if v }
  end
end
