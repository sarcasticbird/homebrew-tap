class Wrap < Formula
  desc "Share a tmux window as an encrypted browser terminal"
  homepage "https://github.com/sarcasticbird/wrap"
  url "https://github.com/sarcasticbird/wrap/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a893f91270ca3df2027fbbf486097f8bd0b32042a6f2c1a0490cc19682fc0941"
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
