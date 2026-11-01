#!/usr/bin/env bash
# Run only against an installed candidate; all Git/GitHub boundaries are synthetic.
set -euo pipefail
prefix="${1:?usage: bash tests/gh-sweep-installed.sh INSTALLED_PREFIX SOURCE_DIRECTORY}"
source_dir="${2:?source archive directory required}"
test -x "$prefix/bin/gh-sweep"
test -x "$prefix/libexec/gh-sweep"
for file in gh-sweep lib/sweep.sh lib/runs.jq; do
  cmp "$prefix/libexec/$file" "$source_dir/$file"
done
"$prefix/bin/gh-sweep" --version
"$prefix/bin/gh-sweep" --help
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/home" "$work/tmp" "$work/repo"
export HOME="$work/home" GH_CONFIG_DIR="$work/home/gh" TMPDIR="$work/tmp"
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
unset GH_TOKEN GITHUB_TOKEN GH_HOST GIT_DIR GIT_WORK_TREE BASH_ENV ENV || true
cd "$work/repo"
git -c core.hooksPath=/dev/null init --quiet
# Git discovery stays inside this empty fixture. gh cannot reach a live service.
gh() {
  printf 'gh %s\n' "$*" >> "$LEDGER"
  case "$*" in
    'repo view --json nameWithOwner --jq .nameWithOwner') echo example/widgets ;;
    'api repos/example/widgets/actions/runs?per_page=100 --paginate --slurp')
      jq -cn '[{total_count:6,workflow_runs:[range(1;7) | {id:.,workflow_id:10,run_attempt:1,
        created_at:"2026-01-01T00:00:00Z",actor:{login:"alice"},
        status:"completed",conclusion:"success"}]}]' ;;
    *) return 92 ;;
  esac
}
export -f gh
export LEDGER="$work/ledger"
: > "$LEDGER"
if "$prefix/bin/gh-sweep" runs --user a/b > "$work/refusal" 2>&1; then
  exit 1
fi
test ! -s "$LEDGER"
grep -F -- '--user requires a login' "$work/refusal"
"$prefix/bin/gh-sweep" runs --dry-run > "$work/preview"
cat "$work/preview"
grep -F 'Retained run: example/widgets/actions/runs/6' "$work/preview"
grep '^Candidate: ' "$work/preview" | cut -d ' ' -f 2- | jq -se 'length == 1 and .[0].id == 1'
test "$(wc -l < "$LEDGER" | tr -d ' ')" = 2
printf 'PASS installed parity, version/help, invalid selector and library-backed preview; no live effects\n'
