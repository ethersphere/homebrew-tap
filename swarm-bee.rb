# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmBee < Formula
  desc "Ethereum Swarm node"
  homepage "https://swarm.ethereum.org/"
  version "1.4.3"
  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ethersphere/bee/releases/download/v1.4.3/bee-darwin-arm64.tar.gz"
      sha256 "18706e56999ffd493773d89cff133ba8869f662326c9c7af0cb54c5a1b1c10e4"

      def install
        (etc/"swarm-bee").mkpath
        (var/"lib/swarm-bee").mkpath
        bin.install ["bee", "bee-get-addr"]
        etc.install "bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethersphere/bee/releases/download/v1.4.3/bee-darwin-amd64.tar.gz"
      sha256 "f04c912c52caabea26145f2045ac6faab12a3e555d13585548cfb5d68ad3158a"

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

  def caveats; <<~EOS
    Logs:   #{var}/log/swarm-bee/bee.log
    Config: #{etc}/swarm-bee/bee.yaml

    Bee requires an Ethereum endpoint to function. By default is using ws://localhost:8546 ethereum endpoint.
    If needed obtain a free Infura account and set:
    swap-endpoint: wss://goerli.infura.io/ws/v3/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    It is recommended to use external signer with bee.
    Check documentation for more info:
    - SWAP https://docs.ethswarm.org/docs/installation/manual#swap-bandwidth-incentives
    - External signer https://docs.ethswarm.org/docs/installation/bee-clef

    After you finish configuration run 'bee-get-addr'.
  EOS
  end

  plist_options :startup => false

  def plist; <<~EOS
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
