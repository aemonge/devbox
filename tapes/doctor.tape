# devbox doctor — the real self-diagnostics path.
# Note: inside a nested sandbox this shows the honest namespace refusal;
# rendered on a capable host it shows the full validation suite.
Output tapes/out/doctor.gif
Set Shell bash
Set FontSize 18
Set Width 950
Set Height 620
Set Theme {"background": "#1e1e2e", "foreground": "#cdd6f4", "black": "#45475a", "red": "#f38ba8", "green": "#a6e3a1", "yellow": "#f9e2af", "blue": "#89b4fa", "magenta": "#f5c2e7", "cyan": "#94e2d5", "white": "#bac2de", "brightBlack": "#585b70", "brightRed": "#f38ba8", "brightGreen": "#a6e3a1", "brightYellow": "#f9e2af", "brightBlue": "#89b4fa", "brightMagenta": "#f5c2e7", "brightCyan": "#94e2d5", "brightWhite": "#a6adc8"}

Type "bin/devbox -- --doctor"
Enter
Sleep 3s
