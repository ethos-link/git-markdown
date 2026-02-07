# git-markdown

[![Gem Version](https://badge.fury.io/rb/git-markdown.svg)](https://badge.fury.io/rb/git-markdown)
[![Ruby](https://github.com/yourusername/git-markdown/actions/workflows/ruby.yml/badge.svg)](https://github.com/yourusername/git-markdown/actions/workflows/ruby.yml)

Convert GitHub pull requests to Markdown for local AI code review. Perfect for offline development workflows with AI assistants like [opencode](https://opencode.ai), GitHub Copilot CLI, and other local code analysis tools.

## Features

- 🚀 **Zero-config authentication** — Automatically uses your existing GitHub credentials
- 📄 **Clean Markdown output** — Review comments, threads, and summaries in a readable format
- 🔍 **Smart filtering** — Filter by comment status (unresolved, resolved, or all)
- 🏢 **Enterprise support** — Works with GitHub Enterprise installations
- 🔒 **Secure** — Respects XDG standards, stores tokens with proper permissions
- ⚡ **Fast** — Minimal dependencies, pure Ruby HTTP client

## Installation

```bash
gem install git-markdown
```

Or add to your Gemfile:

```ruby
gem 'git-markdown'
```

## Quick Start

### 1. Setup (one-time)

```bash
git-markdown setup
```

This will prompt for your GitHub Personal Access Token and store it securely.

### 2. Fetch a PR

From within a git repository:

```bash
git-markdown pr 123
```

Or specify the full repository:

```bash
git-markdown pr owner/repo#123
```

The Markdown file will be saved as `PR-{number}-{title}.md` in your current directory.

## Authentication

git-markdown automatically discovers your GitHub token from multiple sources (in order):

1. `GITHUB_TOKEN` or `GH_TOKEN` environment variables
2. Git credential store (`git credential fill`)
3. GitHub CLI (`gh auth token`)
4. Stored credentials from `git-markdown setup`

This means if you already use `gh` CLI or have git credentials configured, it works out of the box!

## Usage

```bash
# Fetch PR from current repository
git-markdown pr 123

# Fetch PR from specific repository
git-markdown pr owner/repo#123

# Output to stdout for piping
git-markdown pr 123 --stdout | pbcopy

# Save to specific directory
git-markdown pr 123 --output ./reviews/

# Filter comments by status (default: unresolved)
git-markdown pr 123 --status=unresolved
git-markdown pr 123 --status=resolved
git-markdown pr 123 --status=all

# Enable debug output
git-markdown pr 123 --debug

# Show version
git-markdown version
```

## GitHub Enterprise

For GitHub Enterprise installations, set the API URL:

```bash
export GITHUB_API_URL=https://github.yourcompany.com/api/v3
git-markdown pr owner/repo#123
```

## Output Format

The generated Markdown includes:

- **PR metadata** — Title, author, status, and creation date
- **Description** — Full PR body
- **Review comments** — Inline comments grouped by file with line numbers
- **General comments** — PR-level discussion
- **Review summaries** — High-level review approvals/change requests

Comments marked with `[resolved]` or `[done]` are filtered out by default (use `--status=all` to include them).

## Configuration

Configuration is stored in `~/.config/git-markdown/` following XDG standards:

- `config.yml` — General settings (provider, API URL, defaults)
- `credentials` — GitHub token (permissions: 0600)

## Requirements

- Ruby 3.0 or higher
- Git (for remote detection)
- GitHub Personal Access Token with `repo` scope

## Development

```bash
# Clone the repository
git clone https://github.com/yourusername/git-markdown.git
cd git-markdown

# Install dependencies
bundle install

# Run tests
bundle exec rake test

# Run linter
bundle exec standardrb

# Run all checks
bundle exec rake
```

### Building and Installing Locally

To build and install the gem from source:

```bash
# Build the gem
gem build git-markdown.gemspec

# Install the built gem
gem install --local git-markdown-*.gem

# Or install directly from source
bundle exec rake install
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'feat: add some feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Create a new Pull Request

Please use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

## Roadmap

- [ ] GitLab Merge Request support (`git-markdown mr`)
- [ ] GitLab/GitHub Issue support (`git-markdown issue`)
- [ ] Custom templates
- [ ] Include diff in output (optional)

## License

MIT License — see [LICENSE.txt](LICENSE.txt)

## Built With ❤️ By

Crafted with care by the team at **[ethos-link.com](https://ethos-link.com)** — developer productivity tools and workflows for modern software teams.

Also check out **[reviato.com](https://reviato.com)** for AI-powered code review automation that integrates seamlessly with your existing tools.

---

**Love git-markdown?** Star us on GitHub and share with your team!
