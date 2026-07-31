class Wrap < Formula
  desc "Supervise coding-agent terminals in tmux with encrypted browser mirroring"
  homepage "https://github.com/sarcasticbird/wrap"
  url "https://github.com/sarcasticbird/wrap/archive/refs/tags/v0.1.0-beta.4.tar.gz"
  sha256 "24a07fedaf10c64aec06fd811ea113aeff70c9cf07db45a9f031d678a33596df"
  license "Apache-2.0"

  depends_on "go" => :build

  depends_on "tmux"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/wrap"
  end

  def caveats
    <<~EOS
      Encrypted browser mirroring (press `m`) needs cloudflared:
        brew install cloudflared

      Ordinary local use does not require it.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrap version")
  end
end
