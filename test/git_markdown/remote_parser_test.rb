# frozen_string_literal: true

require "test_helper"

class RemoteParserTest < Minitest::Test
  def test_parse_github_https_url
    url = "https://github.com/owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_equal :github, parser.provider
    assert_equal "owner", parser.owner
    assert_equal "repo", parser.repo
    assert parser.valid?
  end

  def test_parse_github_ssh_url
    url = "git@github.com:owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_equal :github, parser.provider
    assert_equal "owner", parser.owner
    assert_equal "repo", parser.repo
    assert parser.valid?
  end

  def test_parse_github_url_without_git_extension
    url = "https://github.com/owner/repo"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_equal :github, parser.provider
    assert_equal "owner", parser.owner
    assert_equal "repo", parser.repo
    assert parser.valid?
  end

  def test_parse_gitlab_url
    url = "https://gitlab.com/owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_equal :gitlab, parser.provider
    assert_equal "owner", parser.owner
    assert_equal "repo", parser.repo
    assert parser.valid?
  end

  def test_parse_invalid_url
    url = "https://bitbucket.org/owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    refute parser.valid?
    assert_nil parser.provider
    assert_nil parser.owner
    assert_nil parser.repo
  end

  def test_full_name
    url = "https://github.com/owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_equal "owner/repo", parser.full_name
  end

  def test_full_name_returns_nil_when_invalid
    url = "https://bitbucket.org/owner/repo.git"
    parser = GitMarkdown::RemoteParser.parse(url)

    assert_nil parser.full_name
  end
end
