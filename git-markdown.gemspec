# frozen_string_literal: true

require_relative "lib/git/markdown/version"

Gem::Specification.new do |spec|
  spec.name = "git-markdown"
  spec.version = GitMarkdown::VERSION
  spec.authors = ["Paulo Fidalgo", "Ethos Link"]
  spec.email = ["devel@ethos-link.com"]

  spec.summary = "Convert GitHub PRs to Markdown for local AI code review"
  spec.description = "A CLI tool that exports GitHub pull requests, review threads and discussion comments to Markdown for local review."
  spec.homepage = "https://www.ethos-link.com/opensource/git-markdown"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 4.0"

  repo = "https://github.com/ethos-link/git-markdown"
  branch = "main"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => repo,
    "bug_tracker_uri" => "#{repo}/issues",
    "changelog_uri" => "#{repo}/blob/#{branch}/CHANGELOG.md",
    "documentation_uri" => spec.homepage,
    "funding_uri" => "https://www.reviato.com/",
    "github_repo" => "ssh://github.com/ethos-link/git-markdown",
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir.chdir(__dir__) do
    Dir["lib/**/*", "bin/git-markdown", "README.md", "LICENSE*", "CHANGELOG.md", "UPGRADE.md"].select { |file| File.file?(file) }.sort
  end
  spec.bindir = "bin"
  spec.executables = ["git-markdown"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.0"

  spec.add_development_dependency "minitest", "~> 6.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
