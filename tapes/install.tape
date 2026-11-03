# devbox install showcase — the real one-liner into a throwaway HOME.
Output tapes/out/install.gif
Set Shell bash
Set FontSize 20
Set Width 950
Set Height 540
Set Theme {"background": "#1e1e2e", "foreground": "#cdd6f4", "black": "#45475a", "red": "#f38ba8", "green": "#a6e3a1", "yellow": "#f9e2af", "blue": "#89b4fa", "magenta": "#f5c2e7", "cyan": "#94e2d5", "white": "#bac2de", "brightBlack": "#585b70", "brightRed": "#f38ba8", "brightGreen": "#a6e3a1", "brightYellow": "#f9e2af", "brightBlue": "#89b4fa", "brightMagenta": "#f5c2e7", "brightCyan": "#94e2d5", "brightWhite": "#a6adc8"}

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
