# Upgrade Guide

Run `bundle exec rake verify` locally before pushing or preparing a release.
GitHub Actions runs commitlint and release packaging/publication only.

## 0.2.0

### Shared development and release tooling

Use Ruby 4 and published Gemkit 0.3.1. Install the bundle and hooks, then run the
project's verification command from the README. Prepare releases from clean,
current main; merging the generated release PR publishes through Actions.
See the [Gemkit upgrade guide](https://github.com/ethos-link/ethos-gemkit/blob/main/UPGRADE.md)
for workflow permissions and registry setup.
