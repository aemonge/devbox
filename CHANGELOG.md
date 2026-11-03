# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- No-clone install: `install.sh` fetches the main tarball automatically
  when piped (`curl ... | bash`) or with `--remote`; the logo persists to
  `PREFIX/share/devbox/` and renders best-effort via `chafa`/kitty `icat`.
- Repository scaffolding: README, LICENSE, CHANGELOG, editor/ignore rules.
- `just` gates: `lint` (shellcheck), `fmt`/`fmt-check` (shfmt), `test` (bats
  syntax + smoke suites), aggregate `check`.
- `install.sh` with dependency checks, prefix install, and self-verification.
- GitHub Actions CI running the lint/format/test gates on ubuntu-latest.
- VHS demo tapes wrapping real `devbox` invocations.

## [0.2.0] - 2026-10-30

### Added

- `devbox` extracted into a standalone repository: mount-isolated developer
  box using Bubblewrap for interactive shells, Pi, OpenCode, and tools.
- Policy-enforcing in-box `git` wrapper (`devbox-git`) denying network
  operations, history rewriting, destructive cleanup, and configuration
  escapes.
- Pi integration: read-only resource closure, machine-local writable state,
  explicit `--allow-pi-config` boundary, command guard with agent-context
  injection.
- OpenCode integration: entry guard plus structural plugin-integrity preflight.
- Integrations: AWS, clipboard, SSH agent (opt-in), Neovim/tmux terminal
  sockets, optional GUI/web-developer mode, host development toolchains.
- `--locked` hardened preset and `--doctor` / `--validate` self-diagnostics.
