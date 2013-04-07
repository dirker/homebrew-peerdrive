require 'formula'

class Peerdrive < Formula
  homepage 'http://peerdrive.org'
  head 'https://github.com/dirker/peerdrive.git', :branch => 'osx-support'

  depends_on 'erlang'
  depends_on 'rebar'
  depends_on 'fuse4x'

  def install
    system "make"
    system "server/install_osx.sh -p \"#{prefix}\""
  end

  def patches
    # fix versioning until a real release is available (rebar git versioning
    # does requires installing from a git repository, but homebrew exports the
    # tree instead of running from the repo)
    DATA
  end

  def caveats; <<-EOS.undent
    In order to launch the peerdrive server please take the following steps:

      1) make sure you read the configuration: #{etc}/peerdrive

      2) Install the launchd entry, like so:

        $ sudo cp -vf #{plist_path} /Library/LaunchDaemons/.
        $ sudo chown -v root:wheel /Library/LaunchDaemons/#{plist_path.basename}

      3) Start the daemon using:

        $ sudo launchctl load /Library/LaunchDaemons/#{plist_path.basename}

    Next boot of system will automatically start peerdrive.
    EOS
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>EnvironmentVariables</key>
      <dict>
        <key>HOME</key>
        <string>~</string>
      </dict>
      <key>ProgramArguments</key>
      <array>
        <string>#{HOMEBREW_PREFIX}/lib/peerdrive/bin/peerdrive</string>
        <string>foreground</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
      <key>StandardErrorPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/server/apps/peerdrive/src/peerdrive.app.src b/server/apps/peerdrive/src/peerdrive.app.src
index 18f6abb..5f22cff 100644
--- a/server/apps/peerdrive/src/peerdrive.app.src
+++ b/server/apps/peerdrive/src/peerdrive.app.src
@@ -3,7 +3,7 @@
 	peerdrive,
 	[
 		{description, "PeerDrive server"},
-		{vsn, git},
+		{vsn, "HEAD"},
 		{applications, [kernel, stdlib, crypto, sasl, ssl]},
 		{mod, {peerdrive_app, []}}
 	]
