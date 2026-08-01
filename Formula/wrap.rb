class Wrap < Formula
  desc "Supervise coding-agent terminals in tmux with encrypted browser mirroring"
  homepage "https://github.com/sarcasticbird/wrap"
  url "https://github.com/sarcasticbird/wrap/archive/refs/tags/v0.1.0-beta.5.tar.gz"
  sha256 "a855508cbeb7384384dc63298548b586f52cb75ba614bbc63582b35b5f80a25a"
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
