# Investigate

> Spec: showcase-install-and-logo · answers the Brainstorm's Questions

## Findings

**Q1 — no-clone install path.** Human confirmed the remote
(github.com/aemonge/devbox) is public, so anonymous HTTPS fetches work.
Candidate paths: (a) per-file fetch of the 7 `bin/` top-level files from
raw.githubusercontent — rejected: the list drifts from `bin/` the first
time a helper is added, and it needs 7+ requests; (b) tarball bootstrap —
`https://github.com/aemonge/devbox/archive/refs/heads/main.tar.gz` in one
request, extracted into a staging dir, then the EXISTING copy+verify brain
runs unchanged with `REPO_ROOT` pointed at the extraction. (b) wins: one
canonical fetch path, zero drift, logo.png rides along, symlink mode
stays repo-only (a symlink into a wiped staging dir is nonsense — remote
mode refuses it with a clear diagnostic). Current installer facts: flags
are `--prefix`, `--symlink`, `-h`; it hard-checks `git` even though it
never invokes git (the runtime needs git — keep the check, it is a
dependency probe, not an invocation); piped invocation (`curl | bash`)
leaves `BASH_SOURCE` unusable for `REPO_ROOT`, which is exactly the
detection signal. Fetch tool: `curl` or `wget`, whichever exists — checked
only in remote mode.

**Q2 — logo display.** `logo.png` is 1.2MB at repo root. Terminal graphics
descending order: `chafa logo.png` (most terminals), `kitty +kitten icat`
(Kitty), plain fallback (print the installed path). All best-effort —
display failure must never fail the install. Persistence: install copies
the logo to `${PREFIX}/share/devbox/logo.png` so the fallback path is
stable after the staging dir is cleaned.

**Q3 — showcase tape.** House style from `tapes/intro.tape`: real
commands, `Output tapes/out/<name>.gif`, Catppuccin Mocha, 950×540,
FontSize 20. The install tape must not touch the real HOME (banked
lesson: throwaway demo homes are fixed-path /tmp dirs wiped at tape
start). Shape: export a demo HOME, wipe it, run the real one-liner, show
the logo landing + `devbox --version` + a first launch. Render is
host-only (VHS Chromium SUID sandbox cannot nest in the box — recorded
lesson pi-vimux-starship/mux). GIF embeds in README once rendered and
committed by Human.

## Test surface

`bin/test/devbox-static-test` asserts installer-adjacent policy through
source assertions; new assertions mirror that helper pattern: remote URL
constant, tarball staging path, piped-detection signal, logo fallback
order, symlink+remote refusal. Lint gates (`shellcheck`, `shfmt -i 4`)
cover install.sh already via `shell_scripts`.
