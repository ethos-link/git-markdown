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
  desc "Full release: update changelog, bump version, commit, tag, and push"
  task :bump, [:level] do |_t, args|
    level = args[:level] || "patch"
    valid_levels = %w[major minor patch pre]

    unless valid_levels.include?(level)
      abort "Invalid level: #{level}. Use: #{valid_levels.join(", ")}"
    end

    branch = `git rev-parse --abbrev-ref HEAD`.strip
    unless ["main", "master"].include?(branch)
      abort "Release must run on main or master. Current: #{branch}."
    end

    unless system("git diff --quiet") && system("git diff --cached --quiet")
      abort "Release requires a clean working tree."
    end

    current = GitMarkdown::VERSION
    parts = current.split(".").map(&:to_i)

    next_version = case level
    when "major"
      "#{parts[0] + 1}.0.0"
    when "minor"
      "#{parts[0]}.#{parts[1] + 1}.0"
    when "patch"
      "#{parts[0]}.#{parts[1]}.#{parts[2] + 1}"
    when "pre"
      "#{parts[0]}.#{parts[1]}.#{parts[2]}.pre.1"
    end

    puts "=== Step 1: Updating CHANGELOG.md for v#{next_version} ==="
    sh "git cliff -c cliff.toml --unreleased --tag v#{next_version} -o CHANGELOG.md"

    if system("git diff --quiet -- CHANGELOG.md")
      puts "Warning: No changelog changes detected"
    else
      puts "✓ Changelog updated"
    end

    puts "\n=== Step 2: Bumping version to #{next_version} ==="

    File.write(
      "lib/git/markdown/version.rb",
      <<~RUBY
        # frozen_string_literal: true

        module GitMarkdown
          VERSION = "#{next_version}"
        end
      RUBY
    )

    puts "✓ Version updated in lib/git/markdown/version.rb"

    puts "\n=== Step 3: Committing changes ==="
    sh "git add CHANGELOG.md lib/git/markdown/version.rb"
    sh "git commit -m \"chore(release): bump version to #{next_version}\""
    puts "✓ Changes committed"

    puts "\n=== Step 4: Creating and pushing tag ==="
    sh "git tag -a v#{next_version} -m \"Release v#{next_version}\""
    sh "git push origin master"
    sh "git push origin v#{next_version}"
    puts "✓ Tag v#{next_version} created and pushed"

    puts "\n✅ Release v#{next_version} prepared successfully!"
    puts "GitHub Actions will now build and publish the release."
  end
end
