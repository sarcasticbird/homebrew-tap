# gh-sweep Candidate

Provisional wiring evidence only. Do not merge this formula as a release.
PR9 is still open; source version delivery, authorized v0.4.1 tag publication,
independent Hawk review, Wren QA and real supported-host evidence remain gates.
No release object, pipeline, host access or Homebrew installation in birds is needed.

## Provenance

| Item | Pinned value |
|---|---|
| Tap base | `e28bbe25a3f6b942d946a740a85545f23b5f9703` |
| Source PR | <https://github.com/sarcasticbird/gh-sweep/pull/9>, open when prepared |
| Source commit | `6a3efb78904ea8e1ff47af2d85b4e772eec190c0` |
| Source tree | `88a6d8efe9db403584a8bf69bac874b41c926614` |
| Actual version | `0.4.0` |
| Archive | <https://github.com/sarcasticbird/gh-sweep/archive/6a3efb78904ea8e1ff47af2d85b4e772eec190c0.tar.gz> |
| Downloaded archive SHA256 | `81ae5aee278964271f29d9bc5ea2b085886c8edcd13f957e4b7c5cce010fefd0` |
| PR9 native source-bundle digest | `9e4e061ebafbf3d2f94c9d46561dd55f00ad9dc902665a8dc850b616c9fda4c0` |

The last two hashes describe different byte streams. Only the downloaded archive
checksum belongs in the formula. Candidate commit/formula hash are captured below
and in the PR receipt, avoiding a self-referential commit hash in this document.
Neither this archive nor old v0.4.0 will be relabeled v0.4.1. After source delivery,
record actual merge commit/tree, new version head and native digest, independent
exact-head gates and authorized tag target. Replace URL/checksum with the actual
v0.4.1 tag archive only after downloading and hashing it; repeat affected gates.

## Author Checks

On aarch64 Linux, archive extraction plus a manually staged equivalent launcher
(using the existing Coop Bash path, not a Homebrew prefix) passed the separate
smoke: executable mode, three-file byte parity, version/help, invalid-selector
refusal and six-run library-backed preview. This is wiring evidence, not an
actual `brew install` or a test of Homebrew's installer. No host Homebrew was
installed or accessed. Ruby syntax and Bash syntax checks passed; the three
unchanged PR9 suites passed 9 disposable-Git checks, 741 safety assertions and
628 branch assertions. ShellCheck and Homebrew style/audit/formula-test were not
run here. The supported-host packet must supply those applicable brew results.

## Supported Host Packet

Chris/operator runs these commands on supported Apple Silicon macOS with existing
Homebrew, not in a bird. Do not access Blackbook remotely for this task. Local Flox
is untouched. Commands use an unlinked candidate, private config/cache and an
explicit Cellar path. Homebrew's existing prefix/Cellar and dependency inventory
are shared: this is not a second Homebrew installation. Stop if gh-sweep is already
installed, the temporary tap exists, or another brew operation is running. Do not
unlink, upgrade or uninstall an existing package to make the test work. Dependencies
may be added; do not autoremove shared dependencies during cleanup.

Run in a fresh Bash shell. Set `CANDIDATE` to the exact 40-character PR head from
the native publication receipt, never a moving branch. Keep the resulting evidence
directory for Wren. Installation failure is evidence, not permission to alter a host.

```bash
set -euo pipefail
export CANDIDATE=REPLACE_WITH_EXACT_PR_HEAD
[[ "$CANDIDATE" =~ ^[0-9a-f]{40}$ ]]
test "$(uname -s)" = Darwin
test "$(uname -m)" = arm64
command -v brew
! brew list --formula | grep -qx gh-sweep
! brew tap | grep -qx robin/gh-sweep-candidate
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALL_UPGRADE=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
export PACKET="$(mktemp -d "${TMPDIR:-/tmp}/gh-sweep-candidate.XXXXXX")"
export HOMEBREW_CACHE="$PACKET/cache"
export HOMEBREW_LOGS="$PACKET/brew-logs"
export GH_CONFIG_DIR="$PACKET/gh-config"
mkdir -p "$GH_CONFIG_DIR"
unset GH_TOKEN GITHUB_TOKEN
{
  date -u; sw_vers; uname -a; brew --version; brew config
  brew list --versions; printf 'candidate=%s\n' "$CANDIDATE"
} > "$PACKET/environment.txt" 2>&1
git clone https://github.com/sarcasticbird/homebrew-tap.git "$PACKET/tap"
git -C "$PACKET/tap" checkout --detach "$CANDIDATE"
test "$(git -C "$PACKET/tap" rev-parse HEAD)" = "$CANDIDATE"
shasum -a 256 "$PACKET/tap/Formula/gh-sweep.rb" > "$PACKET/formula.sha256"
brew tap --custom-remote robin/gh-sweep-candidate "$PACKET/tap"
TAP="$(brew --repository robin/gh-sweep-candidate)"
test "$(git -C "$TAP" rev-parse HEAD)" = "$CANDIDATE"
F=robin/gh-sweep-candidate/gh-sweep
brew style "$F" 2>&1 | tee "$PACKET/style.log"
brew audit --strict "$F" 2>&1 | tee "$PACKET/audit.log"
brew deps --tree "$F" 2>&1 | tee "$PACKET/deps.log"
brew fetch --build-from-source "$F" 2>&1 | tee "$PACKET/fetch.log"
ARCHIVE="$(brew --cache --build-from-source "$F")"
shasum -a 256 "$ARCHIVE" | tee "$PACKET/archive.sha256"
test "$(shasum -a 256 "$ARCHIVE" | cut -d ' ' -f 1)" = \
  81ae5aee278964271f29d9bc5ea2b085886c8edcd13f957e4b7c5cce010fefd0
brew install --build-from-source --skip-link "$F" 2>&1 | tee "$PACKET/install.log"
brew test "$F" 2>&1 | tee "$PACKET/test.log"
PREFIX="$(brew --prefix "$F")"
mkdir "$PACKET/source"
tar -xzf "$ARCHIVE" -C "$PACKET/source" --strip-components=1
"$(brew --prefix bash)/bin/bash" "$PACKET/tap/tests/gh-sweep-installed.sh" \
  "$PREFIX" "$PACKET/source" 2>&1 | tee "$PACKET/installed-smoke.log"
{
  brew list --versions bash gh git jq gh-sweep
  "$(brew --prefix bash)/bin/bash" --version
  "$(brew --prefix git)/bin/git" --version
  "$(brew --prefix gh)/bin/gh" --version
  "$(brew --prefix jq)/bin/jq" --version
  shasum -a 256 "$PREFIX/bin/gh-sweep" "$PREFIX/libexec/gh-sweep" \
    "$PREFIX/libexec/lib/sweep.sh" "$PREFIX/libexec/lib/runs.jq"
  ls -l "$PREFIX/bin/gh-sweep" "$PREFIX/libexec/gh-sweep"
  brew list --versions
} > "$PACKET/installed.txt" 2>&1
printf 'Evidence retained at %s\n' "$PACKET"
```

`brew test` also checks the installed library-backed selector with deny-by-default
shell boundaries. The separate smoke executes the installed launcher, uses a real
empty disposable Git repository and a synthetic exported `gh` function that rejects
every unrecognized call. Its six-run fixture retains five and previews only run 1;
invalid user selection must return nonzero before any GitHub call. No cleanup runs.

Return all logs, commit/formula/archive hashes and operator identity/time privately
to Wren under environment revision `gh-sweep-homebrew-candidate-v1`. A failed style,
audit or install is not a pass; retain its exact output and stop for correction.
Linux syntax/parity/synthetic tests do not establish macOS installation evidence.
The provisional source is not final package clearance. Changed source, formula or
archive invalidates affected evidence and requires a new exact-artifact assessment.

## Cleanup

Only after saving evidence, and only if this packet installed the candidate:

```bash
brew uninstall robin/gh-sweep-candidate/gh-sweep
brew untap robin/gh-sweep-candidate
```

If installation never succeeded, only untap the temporary tap. No linking was
requested, so no previous command needs relinking. Keep newly installed dependencies
unless the operator separately determines they are unused. Delete only the printed
private packet directory when evidence is accepted; do not run `brew cleanup` or
`autoremove`. No user configuration or existing gh-sweep installation is replaced.
