class Wrap < Formula
  desc "Share a tmux window as an encrypted browser terminal"
  homepage "https://github.com/sarcasticbird/wrap"
  url "https://github.com/sarcasticbird/wrap/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "96f953936d84fedfff3e07fb816e9ebd9e8d6402229ca515f89babc1f6666e87"
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
