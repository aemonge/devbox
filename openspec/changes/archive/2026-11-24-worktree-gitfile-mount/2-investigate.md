# Investigate

> Spec: worktree-gitfile-mount · answers the Brainstorm's Questions

## Findings

**Q1 — what git needs from outside the mount.** A linked worktree's
`.git` is a one-line gitfile (`gitdir: <path>`, absolute or relative).
The referenced gitdir (`<main-repo>/.git/worktrees/<name>/`) carries the
worktree-private state — `HEAD`, `index`, `ORIG_HEAD`, `logs/`, local
`refs/` — plus a `commondir` file (typically `../..`) naming the shared
common dir: the main `.git`, which owns `objects/`, `config`,
`packed-refs`, shared `refs/`, `hooks/`, `info/`. Binding the worktree
gitdir alone is therefore never enough: every read that touches history
(status, diff, log) resolves objects through the common dir, so **the
common dir always rides along**. Resolution is fully mechanical at
startup: read the gitfile, resolve the gitdir against the worktree root,
read `commondir` relative to the gitdir, `realpath -m` both. Caveat
found while tracing: `git add` is not read work — it writes blob objects
into the common `objects/` — so with a read-only common dir only true
reads work, and staging fails with an honest write error.

**Q2 — what must be writable for a commit.** Both sides, always: a
commit writes new objects into the common `objects/` and updates `index`
+ `logs/HEAD` (+ worktree `refs/`) inside the worktree gitdir. There is
no read-only commit. Policy shape follows the house rule — the target's
own `.git` is writable by default (`PROTECTED_INFRA_DIRS` skips it under
`ALLOW_GIT=1`, `bin/devbox` ~3641–3672), so the mirrored stance is:
worktree gitdir writable by default, common dir read-only by default
with a clean diagnostic when staging/commit hits it, and a main-`.git`
writable mode only behind an explicit opt-in flag. Rejected candidate:
redirecting object writes via `GIT_OBJECT_DIRECTORY`/alternates env —
it forks the real repo layout, reads like a config escape, and buys
nothing over an honest bind.

**Q3 — detect-and-mount vs fail fast.** The detection point already
exists: `find_repository_root()` (`bin/devbox` ~1420) accepts both
`-d .git` and `-f .git`, so devbox happily mounts a worktree today and
just never follows the gitfile — `[[ -d ${PROJECT_SOURCE_DIR}/.git ]]`
is false for a gitfile, the infra loop binds nothing, and the box starts
clean while every git command starves at discovery, outside the
wrapper's jurisdiction. The mount insertion point is the existing
`SAFE_BINDS`/`add_prepared_bind_once` closure near the infra section —
two extra binds (worktree gitdir, common dir) with the same
default-writable vs `ALLOW_*` policy vocabulary the target `.git`
already uses. Decision for plan: mounts happen automatically at detect
(reads work out of the box), writability of the common dir is the
explicit opt-in, and startup prints one diagnostic line naming the
outside gitdir so the failure can never masquerade as a policy denial
again.

## Test surface

`bin/test/devbox-static-test` source assertions, mirroring the existing
helper pattern: gitfile detection in `find_repository_root`, gitdir +
`commondir` resolution constants/functions, the two new bind insertions,
the opt-in flag name, and the diagnostic string. Live behavior (worktree
box: status green, commit blocked-by-default with the named diagnostic,
opt-in commit green) is a host-side smoke — building a main repo plus
linked worktree pair lives outside the box, same class as the VHS
renders; lint gates (`shellcheck`, `shfmt -i 4`) already cover
`bin/devbox` via `shell_scripts`.
