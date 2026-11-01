# sarcasticbird/homebrew-tap

Homebrew formulae for sarcasticbird tools.

| Formula | Description | Install |
|---------|-------------|---------|
| [coop](https://github.com/sarcasticbird/coop) | Project-scoped Linux sandboxes for coding agents on Apple silicon | `brew install sarcasticbird/tap/coop` |
| [gh-sweep](https://github.com/sarcasticbird/gh-sweep) | Preview and clean attributable GitHub resources | Candidate only: see [test packet](docs/gh-sweep-candidate.md) |
| [to](https://github.com/sarcasticbird/to) | Command-line measurement unit converter | `brew install sarcasticbird/tap/to` |
| [wrap](https://github.com/sarcasticbird/wrap) | Supervise coding-agent terminals in tmux with encrypted browser mirroring | `brew install sarcasticbird/tap/wrap` |

Production formulae build from each project's tagged source release. The provisional
`gh-sweep` candidate pins PR9's immutable commit at version 0.4.0, not the pending
v0.4.1 tag; it is not cleared for merge or distribution. It installs Homebrew Bash
(4+ required), Git, GitHub CLI and jq, with its libraries under `libexec`.
`coop` requires
macOS 26+ on Apple silicon and installs Apple's `container` runtime as a
dependency; `to` runs on macOS and Linux; `wrap` runs on macOS and Linux and
installs `tmux`.
