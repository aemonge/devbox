# Brainstorm

> Spec: scaffold-devbox-repo-tooling · why this exists

## Pain

The repository ships a 3810-line `bin/devbox` plus five sibling guard scripts
with zero repository infrastructure: no README, no license, no changelog, no
lint, no tests, no CI, and no install path. Every change so far was verified by
hand-reading the monolith, so a one-line edit carries the same risk as a
rewrite, and nothing mechanical catches a syntax break or a regression in the
parse-only paths. A developer on a new machine has no discoverable way to go
from clone to a working, verified `devbox`, and no honest demo of what the tool
does.

## Questions

- Q1 — Which canonical toolchain and minimum gates (lint, format, test) are
  enforceable both in-repo and in CI, given the scripts' bash dialect and the
  in-sandbox constraint that nested Bubblewrap launches are refused by design?
- Q2 — What is automatically testable today (syntax, parse-only smoke paths
  such as `--version`/`--help`/`--doctor`) versus what only the future module
  split unlocks, and how does the harness state that boundary honestly instead
  of pretending coverage?
- Q3 — What install/bootstrap contract takes a fresh clone to a verified
  `devbox` on the PATH (dependencies, prefix, symlink, self-check) without
  weakening the sandbox policy or the read-only-infrastructure rules?
- Q4 — Which repo metadata is minimum-viable and truthful — README, LICENSE,
  CHANGELOG, editor/format config, ignore rules, CI workflow — and how are VHS
  demo tapes authored so they demonstrate real commands rather than stagecraft?

<!-- Direction (optional, free): hunch — `just` as the single entrypoint; gates
are shellcheck + shfmt + bats; smoke-first testing because the monolith cannot
be safely sourced; install.sh mirrors the already-documented host symlink;
VHS tapes wrap real invocations of the real binary. -->
