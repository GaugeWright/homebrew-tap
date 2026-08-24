class Whipplescript < Formula
  desc "Control-plane CLI for WhippleScript workflows"
  homepage "https://github.com/GaugeWright/whipplescript"
  version "0.5.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.5.6/whipplescript-aarch64-apple-darwin.tar.xz"
      sha256 "b7c49e0f0cd7ed122aaf962d848ae6287542366b62b2d0c27e41194dab77aa21"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.5.6/whipplescript-x86_64-apple-darwin.tar.xz"
      sha256 "343159fd18c89dd8d94bbfa497ca7df81018df41c7eb1fb50e1e2f17d4cf1c09"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.5.6/whipplescript-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f5042ef5452630868469b6103e9aec2dafcf91400a8ff89cb8a47a0e4095cf87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.5.6/whipplescript-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b559ef73192a8a143822b883b5f2a3825cb2ae5a3b5a72166c4e586999b52842"
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
