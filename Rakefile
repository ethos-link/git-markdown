# frozen_string_literal: true

# Note: Releases are handled automatically by GitHub Actions when you push a tag (e.g., v0.2.0)
# See .github/workflows/release.yml for details
require "bundler/gem_tasks"
require "rake/testtask"
require "standard/rake"
require_relative "lib/git/markdown/version"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: %i[test standard]

namespace :release do
  desc "Bump version (major|minor|patch|pre) and commit"
  task :bump, [:level] do |_t, args|
    level = args[:level] || "patch"
    valid_levels = %w[major minor patch pre]

    unless valid_levels.include?(level)
      abort "Invalid level: #{level}. Use: #{valid_levels.join(", ")}"
    end

    branch = `git rev-parse --abbrev-ref HEAD`.strip
    unless ["main", "master"].include?(branch)
      abort "Version bump must run on main or master. Current: #{branch}."
    end

    unless system("git diff --quiet") && system("git diff --cached --quiet")
      abort "Version bump requires a clean working tree."
    end

    sh "bundle exec gem bump --version 'next #{level}' --commit --tag --push"
  end

  desc "Update changelog, commit, and tag"
  task :prep do
    version = GitMarkdown::VERSION
    branch = `git rev-parse --abbrev-ref HEAD`.strip

    if branch == "HEAD"
      abort "Release prep requires a branch (not detached HEAD)."
    end

    unless ["main", "master"].include?(branch)
      abort "Release prep must run on main or master. Current: #{branch}."
    end

    unless system("git diff --quiet") && system("git diff --cached --quiet")
      abort "Release prep requires a clean working tree."
    end

    sh "git cliff -c cliff.toml --unreleased --tag v#{version} -o CHANGELOG.md"
    if system("git diff --quiet -- CHANGELOG.md")
      puts "No changelog changes. Skipping release prep."
      next
    end

    sh "git add CHANGELOG.md"
    sh "git commit -m \"docs: update changelog for v#{version}\""
    sh "bundle exec gem tag -v #{version}"
    sh "git push"
    sh "git push origin v#{version}"
  end
end
