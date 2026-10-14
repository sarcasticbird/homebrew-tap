class To < Formula
  desc "Command-line measurement unit converter"
  homepage "https://github.com/sarcasticbird/to"
  url "https://github.com/sarcasticbird/to/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "7751a0e8343a6e37d75c011c8db5aa9157a3503fc6bd7caf1a6456a342ecef70"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sarcasticbird/to/internal/cli.Version=v#{version}"), "./cmd/to"
  end

  test do
    assert_equal "to v#{version}\n", shell_output("#{bin}/to --version")
    assert_equal "62.14 mph\n", shell_output("#{bin}/to 100km/h mph")
  end
end
