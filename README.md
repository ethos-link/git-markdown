# git-markdown

Export GitHub pull requests and review threads to a single Markdown file.

For developers reviewing pull-request discussions offline or supplying context to local tools. It exports metadata and discussion; it does not export the code diff. GitLab merge requests and custom templates are not implemented.

[Project and full documentation](https://www.ethos-link.com/opensource/git-markdown) · [RubyGems](https://rubygems.org/gems/git-markdown) · [Changelog](CHANGELOG.md)

## Requirements

Ruby 4.0 or newer. Git is needed to infer the repository from its remote. Authenticate using an existing GitHub credential source or `git-markdown setup`; the token must have access to the requested repository.

## Installation

```sh
gem install git-markdown
```

## Quick start

```sh
gem install git-markdown
git-markdown pr owner/repo#123
```

Replace `owner/repo#123` with an accessible pull request. The command writes `PR-{number}-{title}.md` in the current directory. From a checkout with a GitHub remote, `git-markdown pr 123` infers the repository.

See the [full documentation](https://www.ethos-link.com/opensource/git-markdown) for configuration, workflows, operational details and limitations.
For existing installations, read [UPGRADE.md](UPGRADE.md).

## Development and releases

Shared tooling uses published [Ethos Gemkit](https://github.com/ethos-link/ethos-gemkit).
Keep the exact Gemfile version and workflow commit pins on the same release.

```sh
bundle install
bundle exec lefthook install
bundle exec rake verify
```

Release preparation, publication, registry setup and recovery are documented
in the [Gemkit release guide](https://www.ethos-link.com/opensource/ethos-gemkit#releasing-a-gem).

## About Ethos Link

[Ethos Link](https://www.ethos-link.com) is a software company founded by
[Paulo Fidalgo](https://www.fidalgo.pt). We publish these Ruby tools alongside
our business products:

- [Reviato](https://www.reviato.com): private customer feedback and public review analysis.
- [Nuntio](https://www.nuntiohq.com): prepare, review and schedule social posts.
- [EthosPlaces](https://www.ethos.place): find places, opening hours and contact details.

## License

MIT. See [LICENSE.txt](LICENSE.txt).
