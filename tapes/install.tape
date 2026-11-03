# devbox install showcase — the real one-liner into a throwaway HOME.
Output tapes/out/install.gif
Set Shell bash
Set FontSize 20
Set Width 950
Set Height 540
Set Theme {"name": "Catppuccin Mocha"}

Type "export DEMO_HOME=/tmp/devbox-demo-install"
Enter
Type "rm -rf -- $DEMO_HOME && mkdir -p -- $DEMO_HOME"
Enter
Type "export HOME=$DEMO_HOME"
Enter
Sleep 300ms

Type "curl -fsSL https://raw.githubusercontent.com/aemonge/devbox/main/install.sh | bash"
Enter
Sleep 5s

Type "clear"
Enter
Sleep 400ms

Type "$DEMO_HOME/.local/bin/devbox --version"
Enter
Sleep 1200ms

Type "$DEMO_HOME/.local/bin/devbox --help"
Enter
Sleep 2200ms

Type "chafa $DEMO_HOME/.local/share/devbox/logo.png 2>/dev/null || echo logo at $DEMO_HOME/.local/share/devbox/logo.png"
Enter
Sleep 2200ms
