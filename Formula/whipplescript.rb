class Whipplescript < Formula
  desc "Control-plane CLI for WhippleScript workflows"
  homepage "https://github.com/GaugeWright/whipplescript"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.4.1/whipplescript-aarch64-apple-darwin.tar.xz"
      sha256 "bc6074a2701e1a23b36e7a86f5350d3a925d8b02dc0485385c9080d1061d7c68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.4.1/whipplescript-x86_64-apple-darwin.tar.xz"
      sha256 "8be1261072ab3c4edefa53f51e96e22a447f3eadf83045dc6f702b0bed473bc2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.4.1/whipplescript-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f68435e3b252b2015d66843f67ce7c62706f17e49e3c07afd65b3640297f8e0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.4.1/whipplescript-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "dc4170109d8c4fbcb2de23c7b907325f7fbac348e6afb9ce20ff8208756d5253"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "whip"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "whip"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "whip"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "whip"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
