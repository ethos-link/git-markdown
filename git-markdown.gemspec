# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "git-markdown"
  spec.version = "0.1.0"
  spec.authors = ["ethos-link"]

  spec.summary = "Convert GitHub PRs to Markdown for local AI code review"
  spec.description = "A CLI tool that fetches GitHub pull requests and converts them to Markdown format, perfect for local AI assistants like opencode and codex."
  spec.homepage = "https://github.com/ethos-link/git-markdown"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["git-markdown"]
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 1.0"

  spec.add_development_dependency "minitest", "~> 6.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "standard", "~> 1.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end
