# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class SwarmClef < Formula
  desc "Ethereum Clef"
  homepage "https://swarm.ethereum.org/"
  version "0.4.9"
  bottle :unneeded

  if OS.mac?
    url "https://github.com/ethersphere/bee-clef/releases/download/v0.4.9/bee-clef-darwin-amd64.tar.gz"
    sha256 "e2f844eb41c7137eaaaf127b91106c8ccd850e988dc04293cdcd6707b0d96eb2"
  end

  def install
    (etc/"swarm-clef").mkpath
    (var/"lib/swarm-clef").mkpath
    bin.install ["clef", "packaging/homebrew/swarm-clef", "packaging/homebrew/swarm-clef-init", "packaging/homebrew/swarm-clef-keys"]
    etc.install "packaging/4byte.json" => "swarm-clef/4byte.json" unless File.exists? etc/"swarm-clef/4byte.json"
    etc.install "packaging/rules.js" => "swarm-clef/rules.js" unless File.exists? etc/"swarm-clef/rules.js"
  end

  def post_install
    unless File.exists? "#{var}/lib/swarm-clef/password"
system("openssl", "rand", "-out", var/"lib/swarm-clef/password", "-base64", "32")
end
system(bin/"swarm-clef-init", ">/dev/null", "2>&1")

  end

  def caveats; <<~EOS
    Logs: #{var}/log/swarm-clef/swarm-clef.log
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
    <string>#{bin}/swarm-clef</string>
    <string>start</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>WorkingDirectory</key>
  <string>/usr/local</string>
  <key>StandardOutPath</key>
  <string>#{var}/log/swarm-clef/swarm-clef.log</string>
  <key>StandardErrorPath</key>
  <string>#{var}/log/swarm-clef/swarm-clef.log</string>
</dict>
</plist>

  EOS
  end

  test do
    system "#{bin}/clef --version"
  end
end
