class Coop < Formula
  desc "Project-scoped Linux sandboxes for coding agents on Apple silicon"
  homepage "https://github.com/sarcasticbird/coop"
  url "https://github.com/sarcasticbird/coop/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "70bb4cecf8839bef4a2853dc599c418c166e8355736ce3ac5bea8aced663d88d"
  license "Apache-2.0"

  depends_on "go" => :build
  depends_on "container"
  depends_on arch: :arm64
  depends_on macos: :tahoe

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/coop"
  end

  def caveats
    <<~EOS
      coop needs Apple's container service running:
        container system start
      (or: brew services start container)

      The first time you run coop in a project it offers to build the
      sandbox image; the first build takes a few minutes.

      Verify your host setup with:
        coop doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coop --version")
  end
end
