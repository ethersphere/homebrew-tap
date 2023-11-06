# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmBee < Formula
  desc "Ethereum Swarm node"
  homepage "https://swarm.ethereum.org/"
  version "1.17.6-rc4"
  depends_on :macos

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/ethersphere/bee/releases/download/v1.17.6-rc4/bee-darwin-arm64.tar.gz"
      sha256 "f7b9fe03eb0a08635f666c4357d72746f43ddf9836fb165ba03209cc4ba8a8e9"

      def install
        (etc/"swarm-bee").mkpath
        (var/"lib/swarm-bee").mkpath
        bin.install ["bee", "bee-get-addr"]
        etc.install "bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/ethersphere/bee/releases/download/v1.17.6-rc4/bee-darwin-amd64.tar.gz"
      sha256 "3aba2a805c4f29d8da9efc5f9aa4238729746aaf67185d7642d07d79d0319ae7"

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
