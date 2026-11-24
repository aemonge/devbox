# Plan

> Spec: worktree-gitfile-mount · consult `openspec/learnings/estimation.md` and `skills.md`

## Estimate

~45–60 minutes across three slices · high confidence — every mechanic
was traced in investigate: gitfile → gitdir → `commondir` resolution is
mechanical, the bind closure and the infra-policy path already exist,
and transparency reuses the target-`.git` stance unchanged.

## Skills

- `bash-defensive-patterns` — guards before effects, strict mode
  preserved; governs the `bin/devbox` edit.

## Workflow

Transparent-by-default, per Human's direction: a worktree's repository,
by git's own model, is the gitdir chain — so the chain mounts with the
exact policy a plain `.git` directory would receive, and git just works,
including add and commit, with no second dialect of flags. Read-only-
default-plus-opt-in lost: it broke the one-command-it-works promise and
recreated the folkloric workaround this spec exists to kill; the trust
argument is also consistent — devbox already grants the selected repo's
`.git` writability, and a worktree's metadata is that same repo. Env
redirection of object writes lost (forks the real layout, config-escape
smell). The startup diagnostic stays: it names the chain, so the box
tells the truth about where its repo lives — information, not warning.

## Slices

### Slice 1 — a worktree target names its gitdir chain at startup

- [ ] Resolution step after `find_repository_root()`: read the target's
      `.git` gitfile, resolve the gitdir against the worktree root, read
      `commondir` relative to the gitdir, `realpath -m` both; classify
      each against the target
      check: bash -n, shellcheck, shfmt -i 4 clean
      paths: bin/devbox
- [ ] Startup `info` line naming the mounted gitdir + common dir when
      the chain resolves outside the mount (plain checkouts print
      nothing — zero behavior change)
      paths: bin/devbox
- Commit `fix: name linked-worktree gitdirs at startup`

### Slice 2 — git fully works in a linked-worktree box by default

- [ ] Bind insertion at the existing `SAFE_BINDS`/`add_prepared_bind_once`
      closure: worktree gitdir and common dir bound with the same
      policy a target `.git` directory receives — writable by default,
      read-only under `--ro`/`--locked`/the protected-infra path
      (`ALLOW_GIT=0`), each bound once even when both resolve inside
      the target
      check: bash -n, shellcheck, shfmt -i 4 clean
      paths: bin/devbox
- [ ] Static assertions in the suite: gitfile resolution functions, both
      bind insertions, default-writable and locked variants, diagnostic
      string
      paths: bin/test/devbox-static-test
- Commit `fix: mount linked-worktree gitdirs into the box`

### Slice 3 — the worktree contract is on the README page

- [ ] README Filesystem-boundary paragraph: worktree targets mount their
      gitdir chain transparently with target-`.git` policy; Security
      scope gains the same sentence so the writable outside path is a
      stated fact, not a surprise
      check: markdown lint n/a — content review
      paths: README.md
- Commit `docs: state the linked-worktree mount contract`

## Verification

- Deterministic: `bash -n`, `shellcheck`, `shfmt -i 4` clean; static
  suite green with the new assertions; plain-checkout launches unchanged
  (no diagnostic, no new binds).
- Host-side live smoke: throwaway main repo + linked worktree — box at
  the worktree runs `status`, `diff`, `log`, `add`, `commit` green with
  no extra flags; `--locked` relaunch holds the chain read-only; the
  host commit gate stays Human's.

## History

- (none yet)
