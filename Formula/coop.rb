class Coop < Formula
  desc "Project-scoped Linux sandboxes for coding agents on Apple silicon"
  homepage "https://github.com/sarcasticbird/coop"
  url "https://github.com/sarcasticbird/coop/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "8a9e44920972a1b7a4afa870698d158fa1f94d56a4da6ad435bdf6d27a828601"
  license "Apache-2.0"

  depends_on "go" => :build

  depends_on arch: :arm64
  depends_on "container"
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
