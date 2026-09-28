class Whipplescript < Formula
  desc "Control-plane CLI for WhippleScript workflows"
  homepage "https://github.com/GaugeWright/whipplescript"
  version "0.7.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.7.1/whipplescript-aarch64-apple-darwin.tar.xz"
      sha256 "93acc1366117fe8ea0bae6113f72b83907e5ce6ea0bbf57725cb7e51d6089c5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.7.1/whipplescript-x86_64-apple-darwin.tar.xz"
      sha256 "043231375dab1662913c8d8830245f405e9e679ed51f9a90ff99d11286797ea5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.7.1/whipplescript-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7733d8d87301c16dd31782a8c25a0fbe452e29bcbb203a315effd938b460aa5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/GaugeWright/whipplescript/releases/download/v0.7.1/whipplescript-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2432836b551650ef3d9a6c20b3c801c9556b65ae7d6aa099116c90c3932c67d7"
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
