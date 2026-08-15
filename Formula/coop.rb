class Coop < Formula
  desc "Project-scoped Linux sandboxes for coding agents on Apple silicon"
  homepage "https://github.com/sarcasticbird/coop"
  url "https://github.com/sarcasticbird/coop/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "5d2f61bf45e2d3bdf3ba5e2afdcfc34a1565c65c9b29ea012e49a0fe5fc77415"
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
