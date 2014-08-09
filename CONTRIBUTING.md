# Contributing to kibana-rack

Thank you for interest in contributing to kibana-rack!

kibana-rack uses GitHub issues for discussion, issues, and contributions. There are two main ways to contribute to kibana-rack:

One of the goals of kibana-rack is to make it easy for the community to contribute changes. To that end, here are detailed guidelines on how to contribute to kibana-rack.

* Report an issue or make a feature request at kibana-rack's [issue tracker](https://github.com/tabolario/kibana-rack/issues)
* Contribute features and fix bugs yourself by contributing code to kibana-rack (see below).

## Issues

Issue tracking for kibana-rack happens on GitHub Issues. If you've found a bug or have a feature that you'd like to see implemented, please report it on the issue tracker. [Discussion-only issues](#discussions) are also welcome.

### Bug reports

To minimize the time spent by maintainers in diagnosing and fixing bugs, please use the following template when filing a bug report:

```markdown
### Version

[Version of kibana-rack installed, or commit SHA if installed from Git]

### Environment

Operating system: [Your operating system and version, (e.g. Mac OS X 10.9)
Ruby version: [Version of Ruby installed (run `ruby --version`)
Rails version: [Version of Rails installed if mounting kibana-rack in a Rails application (run `bundle show rails`)]
Sinatra version: [Version of Sinatra installed if mounting kibana-rack in a Sinatra application (run `bundle show sinatra`)]

[Include any other information about your environment that might be helpful]

### Scenario

[What are you attempting to do that isn't working?]

### Steps to reproduce

[What are the things we need to do in order to reproduce the problem?]

### Expected result:

[What are you expecting to happen when the above steps to reproduce are performed?]

### Actual result:

[What actually happens when the above steps to reproduce are performed?]
```

### Security issues

If you have discovered an issue with kibana-rack of a sensitive nature that could compromise the security of kibana-rack users, **please report it securely by sending a GPG-encrypted message instead of filing an issue on GitHub**. Please use the following key and send your report to [tony@tabolario.com](mailto:tony@tabolario.com).

[https://raw.github.com/tabolario/kibana-rack/tabolario.gpg](https://raw.github.com/tabolario/kibana-rack/tabolario.gpg)

The fingerprint of the key should be:

    6EED 2359 968F 7734 06A4 AB56 D90E 487A 60F1 0579

### Discussions

Issues to discuss the architecture, design, and functionality of kibana-rack are welcome on the issue tracker, and this is where these discussions are preferred so that we can track them and associate them with issues if necessary.

## Pull requests

### Getting started

* [Fork](https://github.com/tabolario/kibana-rack/fork) the repository on GitHub.
* Install development dependencies: `bundle`
* Install the pre-commit hook: `bundle exec rake overcommit --install`
* Make sure the existing test suite runs for you: `bundle exec rake`

### Making changes

* Create a topic branch for your work.
  - Prefer to target `master` for new topic branches (`git checkout -b feature/my-new-feature master`).
  - Only target release branches if your change *must* be for that release.
  - Avoid working directly on the `master` branch.
* Make atomic commits of logical units.
* Check to make sure your changes adhere to the project style guide and linter configuration with `bundle exec rake lint`. (This is done automatically if you have the pre-commit hook installed.)
* Write unit and integration tests as necessary for your changes. **Pull requests will not be accepted for non-trivial changes without tests.**
* Ensure that the entire test suite passes with `bundle exec rake spec`.
* Create a pull request on GitHub for your contribution.
* Check [Travis CI](https://travis-ci.org/tabolario/kibana-rack/pull_requests) for your pull request. **Only green pull requests will be merged.**

### Trivial changes

Certain types of changes do not need to undergo the same process as changes involving the functionality of kibana-rack (e.g. running tests and static analysis tools). These types of changes include:

* Changes to "root documentation" like `README.md`, `CHANGELOG.md`, and this document
* Changes to build scripts, and other development configuration files
* Comment cleanup
* Formatting cleanup
* Spelling/grammar fixes
* Typo corrections

Trivial changes **do** need to pass the Ruby linter (`bundle exec rake lint:ruby`) if they make changes to any Ruby code.

## Getting help

A number of support channels are available for getting help with kibana-rack:

* Email: [tony@tabolario.com](mailto:tony@tabolario.com)
* Twitter: [@tabolario](https://twitter.com/tabolario)
