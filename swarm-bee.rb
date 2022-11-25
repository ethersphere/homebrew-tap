# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmBee < Formula
  desc "Ethereum Swarm node"
  homepage "https://swarm.ethereum.org/"
  version "1.10.0-rc11"
  depends_on :macos

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ethersphere/bee/releases/download/v1.10.0-rc11/bee-darwin-amd64.tar.gz"
      sha256 "57c0375a43b02febb80fda3c7a0ba3c54477bd7fcb67481de59fcedbe33f2885"

      def install
        (etc/"swarm-bee").mkpath
        (var/"lib/swarm-bee").mkpath
        bin.install ["bee", "bee-get-addr"]
        etc.install "bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/ethersphere/bee/releases/download/v1.10.0-rc11/bee-darwin-arm64.tar.gz"
      sha256 "163281532b1cb948648e7a72104cedf40f45994837d518e4bee8b7a482fb98a9"

      def install
        (etc/"swarm-bee").mkpath
        (var/"lib/swarm-bee").mkpath
        bin.install ["bee", "bee-get-addr"]
        etc.install "bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
      end
    end
  end

  def post_install
    unless File.exists? "#{var}/lib/swarm-bee/password"
    system("openssl", "rand", "-out", var/"lib/swarm-bee/password", "-base64", "32")
    end
    system(bin/"bee", "init", "--config", etc/"swarm-bee/bee.yaml", ">/dev/null", "2>&1")
  end

  def caveats
    <<~EOS
      Logs:   #{var}/log/swarm-bee/bee.log
      Config: #{etc}/swarm-bee/bee.yaml

      Bee requires a Gnosis Chain RPC endpoint to function. By default this is expected to be found at ws://localhost:8546.

      Please see https://docs.ethswarm.org/docs/installation/install for more details on how to configure your node.

      After you finish configuration run 'sudo bee-get-addr' and fund your node with XDAI, and also XBZZ if so desired.
    EOS
  end

  plist_options startup: false

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>KeepAlive</key>
  <true/>
  <key>Label</key>
  <string>#{plist_name}</string>
  <key>ProgramArguments</key>
  <array>
    <string>#{bin}/bee</string>
    <string>start</string>
    <string>--config</string>
    <string>#{etc}/swarm-bee/bee.yaml</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>#{var}/log/swarm-bee/bee.log</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/swarm-bee/bee.log</string>
</dict>
</plist>

    EOS
  end

  test do
    system "#{bin}/bee version"
  end
end
