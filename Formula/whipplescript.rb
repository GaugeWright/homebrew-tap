class Whipplescript < Formula
  desc "Control-plane CLI for WhippleScript workflows"
  homepage "https://github.com/GaugeWright/whipplescript"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.6.0/whipplescript-aarch64-apple-darwin.tar.xz"
      sha256 "743761071b6b3caac002a4aed360fc25733486b7e9fc3db5fb36e523c7ebe24e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.6.0/whipplescript-x86_64-apple-darwin.tar.xz"
      sha256 "2697cc1447472a661e40e23aaea6c0008c12737d21250b54f4c35091b50b8952"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.6.0/whipplescript-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3820d0a8c5b48e0a2611373036cca2c5a022f5c44555434d156623a9eacb4e50"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.6.0/whipplescript-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "207231d427bb19ab53e30ab4e132f50b1d93b859c72dc9e10284a07502314707"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
