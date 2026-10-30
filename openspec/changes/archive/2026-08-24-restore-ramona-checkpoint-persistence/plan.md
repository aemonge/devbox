# Plan: Restore Ramona checkpoint persistence across devbox exit

**Idea:** `persist-bounded-ramona-state-in-devbox`
**Method:** Fix

**Symptom:** The clean Happy-path run
`ramona-happy-path-mt6z05hc-3e91f0` created and verified an owner-only checkpoint
under `$XDG_STATE_HOME/ramona/checkpoints`, marked its Step complete, and exited
successfully. After devbox exited, the checkpoint was absent from host state
while OpenSpec still claimed it existed.

**Cause:** `bind_pi_xdg_resources` persistently binds only the `pi` XDG state and
cache namespaces. The sandbox path `$XDG_STATE_HOME/ramona` remains on the
disposable home tmpfs, so Ramona checkpoint bytes vanish at process exit.

**Bounded repair:** In normal persistent devbox modes, bind only the host
`$XDG_STATE_HOME/ramona` namespace writable at the canonical sandbox XDG state
location and keep it private. Locked mode remains ephemeral. Do not expose or
bind the complete XDG state tree. Modify only `bin/devbox`, directly relevant
`bin/test/devbox-*` coverage, and matching OpenSpec progress.

**Regression check:** A default writable box writes a `0600` checkpoint beneath
`0700` Ramona state directories, exits, and the host observes identical bytes.
A second box reads them. Locked mode does not persist writes. Custom XDG state
roots map correctly. Unrelated state remains absent, existing Pi state behavior
passes, and the complete host devbox validation suite remains green.

## Value

Ramona's private non-Git Step checkpoints remain available after devbox exits,
so Taskflow progress and recoverable history stay at the same durable boundary.

## Acceptance criteria

- [x] Default devbox persists only Ramona's named XDG state namespace.
- [x] Persisted checkpoint directories are `0700` and files are `0600`.
- [x] A fresh devbox reads identical checkpoint bytes after the writer exits.
- [x] Locked mode stays ephemeral and unrelated XDG state stays hidden.
- [x] Custom XDG state roots, Pi state, and existing sandbox policy still pass.
- [x] A fresh Ramona Happy-path canary leaves its checkpoint on the host.
- [x] Human validated persistence before the Task-boundary commit.

## Scope and boundaries

Included: `/home/aemonge/usr/bin/devbox`, only directly relevant
`/home/aemonge/usr/bin/test/devbox-*` tests, and this Plan's progress/history.
Excluded: broad XDG state exposure, unrelated Pi/OpenCode state, credentials,
network, device policy, Galactica flow changes, rewriting either failed canary,
and history rewriting.

The existing untracked `.pi/` and `bin/.pi/` paths are pre-existing and excluded.

## Method and environment

Use **Fix** through `ramona-fix` in a diagnosed writable devbox. This is the
consumer-acceptance loop's third and final Fix route. The repair is self-hosting:
static and parser checks may run in the implementation box, while complete live
validation must run from a normal host namespace. A namespace denial is failure
evidence, never a pass or permission to bypass the boundary.

Final history target: `fix(devbox): persist bounded Ramona checkpoints`.
Successful Step history uses
`step(devbox): persist bounded Ramona checkpoints`. Human alone validates and
decides history rewriting.

## Verification

Before mutation, preserve the discriminating evidence: write a unique checkpoint
inside default devbox, observe it there, exit, and prove the host path absent.

Focused checks cover shell syntax, static mount-plan assertions, parser output,
default write/exit/read persistence, permissions, locked ephemerality, custom
XDG state, hidden unrelated state, and existing Pi state behavior. Then run every
available `bin/test/devbox*-test` and `bin/devbox -- --validate` from the host.
Finally rerun a fresh Ramona Happy-path canary and verify its checkpoint after Pi
exits.

Human validated the host checkpoint bytes, `0700` directories, `0600` files,
and manifest integrity with `VALID` at 2026-08-24T09:14:58Z.
