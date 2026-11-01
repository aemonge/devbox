# Plan

> Spec: scaffold-devbox-repo-tooling · the contract for execution

## Estimate

~2 hours across six slices, medium-high confidence. Unknowns that could add
time: shellcheck's finding count on 5,700 lines of untouched bash (bounded —
fixes are style-or-directive only), and whether VHS can render in-sandbox
(bounded — falls back to shipped tapes plus a documented host step).

## Skills

- `bash-defensive-patterns` — governs the new shell this change adds
  (justfile recipes, install.sh) and the shellcheck remediation of `bin/*`.
- bare otherwise — no other loaded skill matches repo scaffolding, bats
  harnesses, or VHS tapes; `coding-guidelines` is Rust-scoped and does not
  qualify.

## Workflow

Direct scaffold, one slice per commit, using the toolchain Investigate found
already installed (`just`, `shellcheck`, `shfmt`, `bats`, `vhs`). The
Alternatives lost as follows: Make- lost because `just` is present, reads
better for multi-command gates, and the Human asked for "just lint, just
test" verbatim; sed-extraction unit tests lost because extracting functions
from a moving 3,810-line file lies about coverage — real unit tests wait for
the module split; Docker-in-CI lost because nested-namespace images are
fragile maintenance for a change whose testable surface is syntax and
parse-only paths.

## Slices

### Slice 1 — repo metadata

- [ ] README.md — what/why, install, usage mirroring `usage()`, security
      snapshot, development section (`just` targets), Linux-only scope note
- [ ] LICENSE — MIT, holder `aemonge` (Human may swap before publish)
- [ ] CHANGELOG.md — `0.2.0` baseline from `PROGRAM_VERSION`
- [ ] .editorconfig, .gitignore (VHS renders, bats/test scratch)
- Commit `docs: add repo metadata and ignore rules` + post-commit Human
  validation ask

### Slice 2 — lint and format gates

- [ ] .shellcheckrc with a bash dialect policy
- [ ] shellcheck every `bin/*` script; fix findings minimally or add
      justified inline directives; `bash -n` after every touched file
- [ ] justfile: `lint`, `fmt`, `fmt-check`, aggregate `check`
- Commit `chore: add shell lint and format gates` + post-commit Human
  validation ask

### Slice 3 — test harness

- [ ] tests/ bats suites: syntax (`bash -n` per script), smoke (`--version`
      contract, `--help` content, `--validate`/`--doctor` exit paths with
      in-sandbox constraints recorded honestly, env guards to skip where
      bwrap launch is impossible)
- [ ] justfile: `test` (and a reserved `unit` alias for the post-split
      harness)
- Commit `test: add bats syntax and smoke harness` + post-commit Human
  validation ask

### Slice 4 — installer

- [ ] install.sh — repo-root resolve, dependency check (bash; bwrap on
      Linux; git), prefix install of `bin/`, `~/.local/bin/devbox` symlink,
      verify via `devbox --version`; `just install`, `just verify`
- Commit `feat: add install script and just targets` + post-commit Human
  validation ask

### Slice 5 — CI

- [ ] .github/workflows/ci.yml — ubuntu-latest: shellcheck, shfmt check,
      bats; no sandbox launches; push/PR to main
- Commit `ci: add lint and test workflow` + post-commit Human validation ask

### Slice 6 — VHS tapes

- [ ] tapes/*.tape wrapping real invocations (`--version`, `--doctor`)
- [ ] justfile `record` target; one in-sandbox render attempt, honest debt
      note if the sandbox refuses
- Commit `docs: add vhs demo tapes` + post-commit Human validation ask

## Verification

- Deterministic, per slice: `just lint && just fmt-check && just test` green;
  `bash -n bin/*`; ledger updated in 4-execute.md; `git log --oneline` shows
  exactly the declared commit.
- Whole change: clean `git status`; `openspec status` shows 4/4; the
  human-only act is re-running `just check` on the host and replying with the
  verdict.

## History

- `docs: add repo metadata and ignore rules`
- `chore: add shell lint and format gates`
- `test: add bats syntax and smoke harness`
- `feat: add install script and just targets`
- `ci: add lint and test workflow`
- `docs: add vhs demo tapes`
