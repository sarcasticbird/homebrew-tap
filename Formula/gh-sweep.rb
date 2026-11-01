class GhSweep < Formula
  desc "Preview and clean attributable GitHub resources"
  homepage "https://github.com/sarcasticbird/gh-sweep"
  # Provisional PR9 candidate, not the final v0.4.1 distribution archive.
  url "https://github.com/sarcasticbird/gh-sweep/archive/6a3efb78904ea8e1ff47af2d85b4e772eec190c0.tar.gz"
  version "0.4.0"
  sha256 "81ae5aee278964271f29d9bc5ea2b085886c8edcd13f957e4b7c5cce010fefd0"
  license "MIT"

  depends_on "bash"
  depends_on "gh"
  depends_on "git"
  depends_on "jq"

  def install
    libexec.install "gh-sweep", "lib"
    (bin/"gh-sweep").write <<~EOS
      #!#{Formula["bash"].opt_bin}/bash
      export PATH="#{Formula["bash"].opt_bin}:#{Formula["gh"].opt_bin}:#{Formula["git"].opt_bin}:#{Formula["jq"].opt_bin}:$PATH"
      exec "#{Formula["bash"].opt_bin}/bash" "#{libexec}/gh-sweep" "$@"
    EOS
    chmod 0755, bin/"gh-sweep"
  end

  test do
    assert_equal "gh-sweep v#{version}\n", shell_output("#{bin}/gh-sweep --version")
    assert_match "--keep-runs N", shell_output("#{bin}/gh-sweep --help")
    assert_match "--user requires a login", shell_output("#{bin}/gh-sweep runs --user a/b 2>&1", 1)
    assert_path_exists libexec/"lib/sweep.sh"
    assert_path_exists libexec/"lib/runs.jq"
    assert_predicate libexec/"gh-sweep", :executable?

    # Source the installed payload so mock boundaries cannot fall through to gh/git.
    (testpath/"preview.sh").write <<~EOS
      set -euo pipefail
      source "#{libexec}/gh-sweep"
      git() {
        [[ "$*" == "rev-parse --show-toplevel" ]] || return 91
        printf '%s\\n' "$PWD"
      }
      gh() {
        case "$*" in
          'repo view --json nameWithOwner --jq .nameWithOwner') echo example/widgets ;;
          'api repos/example/widgets/actions/runs?per_page=100 --paginate --slurp')
            jq -cn '[{total_count:6,workflow_runs:[range(1;7) | {id:.,workflow_id:10,run_attempt:1,
              created_at:"2026-01-01T00:00:00Z",actor:{login:"alice"},
              status:"completed",conclusion:"success"}]}]' ;;
          *) return 92 ;;
        esac
      }
      main runs --dry-run
    EOS
    output = shell_output("#{Formula["bash"].opt_bin}/bash #{testpath}/preview.sh")
    assert_match '"id":1', output
    assert_match "Retained run: example/widgets/actions/runs/6", output
  end
end
