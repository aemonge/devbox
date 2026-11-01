# devbox doctor — the real self-diagnostics path.
# Note: inside a nested sandbox this shows the honest namespace refusal;
# rendered on a capable host it shows the full validation suite.
Output tapes/out/doctor.gif
Set Shell bash
Set FontSize 18
Set Width 950
Set Height 620
Set Theme {"name": "Catppuccin Mocha"}

Type "bin/devbox --doctor"
Enter
Sleep 3s
