# git-markdown

[![Gem Version](https://badge.fury.io/rb/git-markdown.svg)](https://badge.fury.io/rb/git-markdown)
[![Ruby](https://github.com/ethos-link/git-markdown/actions/workflows/ruby.yml/badge.svg)](https://github.com/ethos-link/git-markdown/actions/workflows/ruby.yml)

Convert GitHub pull requests into a single Markdown file you can review locally. Useful for offline or local AI review workflows with tools like [opencode](https://opencode.ai), GitHub Copilot CLI, and your own scripts.

## Features

- Reuse existing GitHub credentials.
- Export PR details, threads and summaries as Markdown.
- Filter threads by status and write to a file or stdout.
- Use GitHub Enterprise and local credential storage with restricted permissions.

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
git-markdown pr 123 --stdout | pbcopy  # macOS; on Linux use `xclip`/`wl-copy` or redirect to a file

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

If you see a prompt for a GitHub username or an askpass error, set `GITHUB_TOKEN` or `GH_TOKEN` in your environment to skip git credential prompts.

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

- Ruby 4.0+
- Git (for remote detection)
- GitHub Personal Access Token with `repo` scope

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
- RubyGems: [rubygems.org/gems/git-markdown](https://rubygems.org/gems/git-markdown)

## License

MIT License, see [LICENSE.txt](LICENSE.txt)

## Development and releases

Shared tooling uses published [Ethos Gemkit](https://github.com/ethos-link/ethos-gemkit).
Keep the exact Gemfile version and workflow commit pins on the same release.

```sh
bundle install
bundle exec lefthook install
bundle exec rake verify
```

From clean, current `main`, run `bundle exec rake 'release:prepare[patch]'`
(or `minor`, `major`, or an explicit version). Review and merge the generated
release PR to publish through Actions. Shared prerequisites, registry credentials
and failed-job recovery are in the [Gemkit release guide](https://github.com/ethos-link/ethos-gemkit#releasing-a-gem).

## Built by Ethos Link

[Ethos Link](https://www.ethos-link.com) builds business software and integrations
that replace manual handoffs with connected workflows. We help teams automate
routine work, use their data and improve the processes their business runs on.

- [Reviato](https://www.reviato.com): Read public review trends and collect
  private customer feedback, so your team can decide what to improve.
- [EthosPlaces](https://www.ethos.place): Give customers the details they need to
  choose and visit your business, from opening hours to directions.
- [Nuntio](https://www.nuntiohq.com): Draft, review and schedule social posts in
  one workspace, then track each publishing result.
