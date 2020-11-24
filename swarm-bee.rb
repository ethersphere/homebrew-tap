# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmBee < Formula
  desc "Ethereum Swarm node"
  homepage "https://swarm.ethereum.org/"
  version "0.4.0"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/ethersphere/bee/releases/download/v0.4.0/bee-darwin-amd64.tar.gz"
    sha256 "147ce13d980f33d344abab9a8fd394b125ae088ce40f5f02fe64a69ab2a3e39e"
  end

  def install
    (etc/"swarm-bee").mkpath
    (var/"lib/swarm-bee").mkpath
    bin.install ["bee", "packaging/homebrew/bee-get-addr"]
    etc.install "packaging/homebrew/bee.yaml" => "swarm-bee/bee.yaml" unless File.exists? etc/"swarm-bee/bee.yaml"
  end

  def post_install
    system("openssl", "rand", "-base64", "32", "-out", var/"lib/swarm-bee/password")
system(bin/"bee", "init", "--config", etc/"swarm-bee/bee.yaml", ">/dev/null", "2>&1")

  end

  def caveats; <<~EOS
    Logs:   #{var}/log/swarm-bee/bee.log
    Config: #{etc}/swarm-bee/bee.yaml
    
    Bee has SWAP enabled by default and it needs ethereum endpoint to operate.
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
  <key>WorkingDirectory</key>
  <string>/usr/local</string>
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