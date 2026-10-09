class Whipplescript < Formula
  desc "Control-plane CLI for WhippleScript workflows"
  homepage "https://github.com/GaugeWright/whipplescript"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.11.0/whipplescript-aarch64-apple-darwin.tar.xz"
      sha256 "8316b3c6aaf1a6c2adf29316d332e53bc628aee454aa46a3e2f03907228a690f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.11.0/whipplescript-x86_64-apple-darwin.tar.xz"
      sha256 "4962b1dd56e8ee9503ad250368c9d8f762264759d911b718a8261765be921408"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.11.0/whipplescript-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e73cd800f118ad41fe5e22bd5366a58176a91b56422dd60de50734cb446261d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.11.0/whipplescript-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c886d4615d2835859839cf50758b8e78d8c6496896d98324fda4c51d5aef1cff"
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
