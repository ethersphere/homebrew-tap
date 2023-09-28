# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmBee < Formula
  desc "Ethereum Swarm node"
  homepage "https://swarm.ethereum.org/"
  version "1.18.0-rc1"
  depends_on :macos

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/ethersphere/bee/releases/download/v1.18.0-rc1/bee-darwin-amd64.tar.gz"
      sha256 "48396c6ef3ea119a11b174ff62f01f5c6434cd6d46f9dcf082043cf0ce139f86"

      def install
        (etc/"swarm-bee").mkpath
        (var/"lib/swarm-bee").mkpath
        bin.install ["bee", "bee-get-addr"]
        etc.install "bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/ethersphere/bee/releases/download/v1.18.0-rc1/bee-darwin-arm64.tar.gz"
      sha256 "6202cf798abefcc2836e9a5f83b5f057807c45da87f44e4f72a753f8b9c7e960"

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

      After you finish configuration run 'bee-get-addr' and fund your node with XDAI, and also XBZZ if so desired.
    EOS
  end

  service do
    run [bin/"bee", "start", "--config", etc/"swarm-bee/bee.yaml"]
    keep_alive true
    error_log_path var/"log/swarm-bee/bee.log"
    log_path var/"log/swarm-bee/bee.log"
  end

  test do
    system "#{bin}/bee version"
  end
end
