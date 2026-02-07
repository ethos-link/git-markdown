# git-markdown

[![Gem Version](https://badge.fury.io/rb/git-markdown.svg)](https://badge.fury.io/rb/git-markdown)
[![Ruby](https://github.com/ethos-link/git-markdown/actions/workflows/ruby.yml/badge.svg)](https://github.com/ethos-link/git-markdown/actions/workflows/ruby.yml)

Convert GitHub pull requests into a single Markdown file you can review locally. Useful for offline or local AI review workflows with tools like [opencode](https://opencode.ai), GitHub Copilot CLI, and your own scripts.

## Features

- 🔐 Zero-config auth: uses your existing GitHub credentials
- 🧾 Clean output: PR details, threads, and summaries in readable Markdown
- 🧰 Practical controls: filter by status, write to file or stdout, debug when needed
- 🏢 GitHub Enterprise support, plus safe local credential storage (XDG-style, tight perms)

## Install

```bash
gem install git-markdown
```

## Quick start

### 1) Setup (optional)

```bash
git-markdown setup
```

### 2) Export a PR

From inside a git repository:

```bash
git-markdown pr 123
```

Or specify the repo:

```bash
git-markdown pr owner/repo#123
```

It saves `PR-{number}-{title}.md` in the current directory by default.

## Usage

```bash
# Export PR from current repository
git-markdown pr 123

# Export PR from a specific repository
git-markdown pr owner/repo#123

# Output to stdout (useful for piping)
git-markdown pr 123 --stdout | pbcopy

# Save to a directory
git-markdown pr 123 --output ./reviews/

# Filter comment threads (default: unresolved)
git-markdown pr 123 --status=unresolved
git-markdown pr 123 --status=resolved
git-markdown pr 123 --status=all

# Debug output
git-markdown pr 123 --debug

# Show version
git-markdown version
```

## Authentication

`git-markdown` looks for a GitHub token in this order:

1. `GITHUB_TOKEN` or `GH_TOKEN` environment variables
2. Git credential store (`git credential fill`)
3. GitHub CLI (`gh auth token`)
4. Token saved by `git-markdown setup`

## GitHub Enterprise

Set your API URL:

```bash
export GITHUB_API_URL=https://github.yourcompany.com/api/v3
git-markdown pr owner/repo#123
```

## Output

The generated Markdown includes:

- PR metadata (title, author, status, created date)
- PR description (full body)
- Review comments grouped by file with line numbers
- General discussion comments
- Review summaries (approvals, change requests)

Threads marked with `[resolved]` or `[done]` are filtered out by default. Use `--status=all` to include them.

## Configuration

Config is stored under `~/.config/git-markdown/`:

- `config.yml` for settings (provider, API URL, defaults)
- `credentials` for the token (permissions: 0600)

## Requirements

- Ruby 3.0+
- Git (for remote detection)
- GitHub Personal Access Token with `repo` scope

## Development

```bash
git clone https://github.com/ethos-link/git-markdown.git
cd git-markdown

bundle install
bundle exec rake test
bundle exec standardrb
bundle exec rake
```

### Install locally

```bash
rake install
```

## Release

Releases are triggered by pushed tags and use `CHANGELOG.md` for GitHub release notes.
Install `git-cliff` if you want changelog automation: https://github.com/orhun/git-cliff
The release workflow expects a `## [X.Y.Z]` entry in `CHANGELOG.md` that matches the tag.

```bash
# 1) Bump the version (commit created)
bundle exec gem bump -v X.Y.Z

# 2) Prepare release (changelog + tag + push)
bundle exec rake release:prep
```

The release prep task skips if the changelog has no changes.

## Contributing

1. Fork it
2. Create a branch (`git checkout -b feature/my-feature`)
3. Commit your changes
4. Push (`git push origin feature/my-feature`)
5. Open a Pull Request

Please use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages.

## Roadmap

- [ ] GitLab Merge Request support (`git-markdown mr`)
- [ ] GitLab and GitHub Issue support (`git-markdown issue`)
- [ ] Custom templates
- [ ] Optional diff in output

## References

- GitHub REST API docs: [docs.github.com/en/rest](https://docs.github.com/en/rest)
- GitHub CLI auth token: [cli.github.com/manual/gh_auth_token](https://cli.github.com/manual/gh_auth_token)
- Git credential interface: [git-scm.com/docs/git-credential](https://git-scm.com/docs/git-credential)
- XDG Base Directory spec: [specifications.freedesktop.org/basedir-spec](https://specifications.freedesktop.org/basedir-spec/latest/)
- RubyGems: [rubygems.org/gems/git-markdown](https://rubygems.org/)

## License

MIT License, see [LICENSE.txt](LICENSE.txt)

## About

**git-markdown** is built by **[Ethos Link](https://www.ethos-link.com)**, a team creating thoughtful software for modern development workflows. We believe tools should adapt to how you actually work, not the other way around.

If you also manage customer feedback and reviews, check out **[Reviato](https://www.reviato.com)** — we help businesses collect, manage, and respond to customer reviews with less hassle and more results.
