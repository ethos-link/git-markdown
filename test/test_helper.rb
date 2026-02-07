# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "webmock/minitest"
require "vcr"

require "git_markdown"

VCR.configure do |config|
  config.cassette_library_dir = "test/support/cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data("<GITHUB_TOKEN>") { ENV["GITHUB_TOKEN"] }
end

WebMock.enable!

class Minitest::Test
  def setup_test_config
    @test_config_dir = File.join(Dir.tmpdir, "git-markdown-test-#{Time.now.to_i}")
    FileUtils.mkdir_p(@test_config_dir)
    @original_xdg = GitMarkdown::Configuration::XDG_CONFIG_HOME
    GitMarkdown::Configuration.send(:remove_const, :XDG_CONFIG_HOME)
    GitMarkdown::Configuration.const_set(:XDG_CONFIG_HOME, @test_config_dir)
    @test_config_dir
  end

  def teardown_test_config
    return unless @test_config_dir

    FileUtils.rm_rf(@test_config_dir)
    GitMarkdown::Configuration.send(:remove_const, :XDG_CONFIG_HOME)
    GitMarkdown::Configuration.const_set(:XDG_CONFIG_HOME, @original_xdg) if @original_xdg
  end
end
