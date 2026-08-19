class Wrap < Formula
  desc "Share a tmux window as an encrypted browser terminal"
  homepage "https://github.com/sarcasticbird/wrap"
  url "https://github.com/sarcasticbird/wrap/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "31f9294705c6f567881b78604a184dd3b1c0bc28d135ae632847ace70df9f6de"
  license "Apache-2.0"

  depends_on "go" => :build

  depends_on "cloudflared"
  depends_on "tmux"

  on_macos do
    depends_on arch: :arm64
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/wrap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrap version")
  end
end
