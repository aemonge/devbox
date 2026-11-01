# Investigate

> Spec: scaffold-devbox-repo-tooling · answers the Brainstorm's Questions

## Findings

**Q1 — toolchain present, dialect known.** The devbox image already ships the
whole candidate chain: `just`, `shellcheck`, `shfmt`, `bats`, `vhs` (plus
`jq`, `node`, `go`, `cargo` — unneeded for pure bash). All `bin/*` scripts are
`#!/usr/bin/env bash` with `set -[-E]euo pipefail` and heavy bashisms
(`declare -A`, arrays, `[[ =~`, heredocs), so shellcheck targets `bash`
explicitly and shfmt normalizes style, not portability.
`bin/devbox-opencode-integrity` already carries an inline
`# shellcheck disable=SC2034` precedent. Minimum gates: `just lint`
(shellcheck — zero findings, justified inline disables only), `just fmt-check`
(shfmt diff-clean), `just test` (bats). CI runs exactly those three on
`ubuntu-latest`; CI does not launch sandboxes (bwrap-in-CI is unreliable and
out of scope for this change).

**Q2 — testable today vs after the split.** The monolith runs its whole build
at top level (no `main()` guard), so sourcing it under bats is impossible
without side effects. Measured execution boundaries: `--version`/`--help` exit
inside the parse loop; `--validate`/`--doctor` dispatch at lines 3273–3279,
*before* the Linux gate at 3318 and before any `exec bwrap` — both are safe to
invoke in-sandbox. `run_devbox_validation` builds fixtures under `mktemp` and
re-invokes `$0`; whether every sub-case avoids a nested sandbox launch is
measured during execution and recorded as-is (prior ledger: nested launches
are refused inside this box by namespace limits). Today-testable: `bash -n`
syntax on all scripts, `--version` output contract, `--help` usage content,
`--validate`/`--doctor` exit-path behavior. Function-level unit tests require
the `lib/` split (next change) — the harness documents that boundary and
refuses to fake it.

**Q3 — install contract already half-documented.** The
`fix-devbox-auto-mount-project-collision` ledger records the host convention:
scripts live in the repo, `~/.local/bin/devbox` is a symlink, and
`ln -sfn <repo>/bin/devbox ~/.local/bin/devbox` is the host-side step
(`~/.local/bin` is ro-bound inside the sandbox, so the installer targets the
host and must not be run from in-sandbox against `~/.local`).
install.sh therefore: resolves the repo root from its own location, checks
dependencies (`bash` everywhere; `bwrap` only when `uname -s` is Linux;
`git`), copies `bin/` into a prefix (default `~/.local`), creates the symlink,
and verifies with `devbox --version`. Hard-fails honestly on missing deps;
no sudo; no policy changes.

**Q4 — metadata inventory.** Missing today: README.md (what/why, install,
usage, security snapshot, development section pointing at `just` targets),
LICENSE, CHANGELOG.md (baseline `0.2.0` from `PROGRAM_VERSION`), .editorconfig,
.gitignore (VHS renders, test scratch), .github/workflows/ci.yml. VHS is
installed; rendering needs ttyd/ffmpeg/headless Chrome — attempt one
in-sandbox render; if the sandbox refuses (no display stack), ship
`tapes/*.tape` plus `just record` and record the host-render step as debt,
honestly. Tapes wrap real invocations (`devbox --version`, `devbox --doctor`)
— no staged output.

## Verification instruments

- `just lint` / `just fmt-check` / `just test` green before any commit.
- `bash -n bin/*` inside the bats suite.
- `bin/devbox --version` output contract asserted in smoke tests.
- `git log --oneline` shows one commit per slice, nothing else.
- VHS render attempt evidence recorded in the execute ledger.

## Alternatives

1. Make- instead of justfile. · Works everywhere but reads worse for
   multi-command gates; `just` is already installed and the Human asked for
   "just lint, just test" verbatim. · Pick-when: never, unless `just`
   disappears from supported images.
2. Unit tests now by `sed`-extracting functions from the monolith. · Brittle
   extraction of a moving file; lies about coverage. · Pick-when: only if the
   module split is cancelled, which contradicts the confirmed plan.
3. Docker-based CI that actually launches devbox. · High value, high
   maintenance; nested-namespace images are fragile. · Pick-when: after the
   split lands and the test surface is worth a container recipe.
