# Idea: Make devbox cross-platform without weakening its boundary

Developers should use the same `devbox` command and policy intent on Linux and macOS, with each platform selecting a native containment backend and reporting its guarantees honestly. Linux should retain Bubblewrap behavior; macOS should gain a useful native path rather than requiring every Mac developer to invent a separate workflow.

Keep policy shared but backend mechanics explicit. Never silently run unsandboxed, never claim mount-namespace parity from macOS Seatbelt rules, preserve fail-closed conflicts and locked mode, and require live validation on each supported operating system before calling that backend usable.

This Idea may parent multiple independently validated Plans.
