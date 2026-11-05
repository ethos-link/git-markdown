# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2026-11-05


### Changed

- align consumer guidance with Gemkit

- adopt Gemkit 0.3.0

- adopt Gemkit 0.3.0 and align shared guidance ([#15](https://github.com/ethos-link/git-markdown/pull/15))




### Documentation

- clarify current setup

- clarify current setup ([#13](https://github.com/ethos-link/git-markdown/pull/13))




### Fixed

- preserve release lockfile checksums

- preserve release lockfile checksums ([#14](https://github.com/ethos-link/git-markdown/pull/14))



## [0.2.0] - 2026-11-04


### Added

- harden git commits

- harden git commits ([#10](https://github.com/ethos-link/git-markdown/pull/10))

- require Ruby 4 and adopt Gemkit

- require Ruby 4 and adopt Gemkit ([#11](https://github.com/ethos-link/git-markdown/pull/11))




### Documentation

- add conventional changelogs ([#8](https://github.com/ethos-link/git-markdown/pull/8))




### Fixed

- preserve release changelog history ([#9](https://github.com/ethos-link/git-markdown/pull/9))

- standardrb offense



## [0.1.9] - 2026-04-21

### Fixed
- Publish the built gem directly from the release workflow.

### Documentation
- Update the gemspec and README to match the current public positioning and release flow.

### Changed
- Standardize the gem release workflow and repository conventions.
- Stop relying on GitHub variables in the release setup.

## [0.1.8] - 2026-03-20

### Added
- Filter GitHub-native resolved comments via GraphQL so exported review files stay focused on active feedback by default.

## [0.1.7] - 2026-02-08

### Fixed
- Read the CLI version from `GitMarkdown::VERSION` consistently.

## [0.1.6] - 2026-02-08

### Fixed
- Restore RubyGems publishing through the OIDC-compatible `rubygems/release-gem` workflow path.

## [0.1.5] - 2026-02-08

### Fixed
- Publish by building and pushing the gem artifact directly instead of relying on the previous release action flow.

## [0.1.4] - 2026-02-08

### Changed
- Stabilize the release line while iterating on the automated release process.

## [0.1.3] - 2026-02-08

### Fixed
- Add `workflow_call` support to `ruby.yml` and configure RubyGems authentication for the release workflow.
- Allow changelog generation to be optional in the release workflow when needed.

### Changed
- Move to a single-command release process with changelog generation built into release preparation.

## [0.1.1] - 2026-02-08

### Added
- Add the `release:bump` task for automated version management.

### Fixed
- Correct the gem bump flow and release version handling across the early automated release tasks.

### Documentation
- Update the gemspec and changelog during the initial release hardening passes.

## [0.1.0] - 2026-02-08

### Added
- Bootstrap the `git-markdown` gem and its CLI for exporting pull requests into local Markdown files.

### Fixed
- Harden setup and credential handling, including the initial `git-cliff` configuration and CLI UX cleanup.

### Documentation
- Improve the README, metadata, and local development guidance for the first public release.
