# sarcasticbirds/tap

Homebrew formulae for sarcasticbirds tools.

| Formula | Description | Install |
|---------|-------------|---------|
| [to](https://github.com/sarcasticbirds/to) | Command-line measurement unit converter | `brew install sarcasticbirds/tap/to` |

Formulae build from each project's tagged source release. `to` runs on macOS and Linux.

The `wrap` formula is disabled: its retired Go terminal-sharing CLI source
release is no longer available. The current [Wrap](https://github.com/sarcasticbirds/wrap)
is Node-based Apple Container infrastructure and has no supported Homebrew release.

## Using the canonical tap

For a new installation:

```sh
brew tap sarcasticbirds/tap
brew install sarcasticbirds/tap/to
```

For an existing `to` installation, add the canonical tap and inspect before upgrading:

```sh
brew tap sarcasticbirds/tap
brew update
brew info sarcasticbirds/tap/to
brew info --json=v2 to
brew upgrade sarcasticbirds/tap/to
```

Check the installed formula's tap and source metadata in the JSON output,
especially if it was installed from `sarcasticbird/tap`. Adding the new tap
does not prove that an existing installation's old-origin metadata has migrated.
The formula remains at v0.2.0, so a same-version upgrade may be a no-op; verify
the installed metadata again after any upgrade rather than assuming migration.
