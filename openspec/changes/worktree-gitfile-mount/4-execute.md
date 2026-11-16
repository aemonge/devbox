# Execute

> Spec: worktree-gitfile-mount · state: running — plan granted 2026-11-16 · counters below are truth

## Slice 1 — a worktree target names its gitdir chain at startup

- [x] Resolution step after `find_repository_root()`: read the target's
      `.git` gitfile, resolve the gitdir against the worktree root, read
      `commondir` relative to the gitdir, `realpath -m` both; classify
      each against the target
      started_at: ~2026-11-16T13:30Z · ended_at: 2026-11-16T13:37:28Z ·
      total: ~8min · check: bash -n, shellcheck, shfmt -i 4 -d clean;
      live probe — absolute + relative gitfiles both resolve
      gitdir=/…/main/.git/worktrees/wt common=/…/main/.git (exit 0)
      paths: bin/devbox
- [x] Startup `info` line naming the mounted gitdir + common dir when
      the chain resolves outside the mount (plain checkouts print
      nothing — zero behavior change)
      started_at: ~2026-11-16T13:30Z · ended_at: 2026-11-16T13:37:28Z ·
      total: ~8min · check: lint battery green; runtime emission lands
      with the Slice 2/Verification live smoke
      paths: bin/devbox
- [x] fix: name linked-worktree gitdirs at startup
      hash: 670624e

## Slice 2 — git fully works in a linked-worktree box by default

- [x] Bind insertion at the existing `SAFE_BINDS`/`add_prepared_bind_once`
      closure: worktree gitdir and common dir bound with the same
      policy a target `.git` directory receives — writable by default,
      read-only under `--ro`/`--locked`/the protected-infra path
      (`ALLOW_GIT=0`), each bound once even when both resolve inside
      the target
      started_at: 2026-11-16T14:20Z · ended_at: 2026-11-16T14:44:09Z ·
      total: ~25min · check: bash -n, shellcheck, shfmt -i 4 -d clean
      (both scripts); register_bind_destination arbitrates overlaps with
      user --add/--add-rw (dedupe · writable-takes-over · fail-closed
      on source disagreement)
      paths: bin/devbox
- [x] Static assertions in the suite: gitfile resolution functions, both
      bind insertions, default-writable and locked variants, diagnostic
      string
      started_at: 2026-11-16T14:20Z · ended_at: 2026-11-16T14:44:09Z ·
      total: ~25min · check: full suite green — 8 new worktree asserts
      PASS, exit 0
      paths: bin/test/devbox-static-test
- [x] fix: mount linked-worktree gitdirs into the box
      hash: ae988c7

## Slice 3 — the worktree contract is on the README page

- [x] README Filesystem-boundary paragraph: worktree targets mount their
      gitdir chain transparently with target-`.git` policy; Security
      scope gains the same sentence so the writable outside path is a
      stated fact, not a surprise
      started_at: 2026-11-16T14:45Z · ended_at: 2026-11-16T14:47Z ·
      total: ~2min · check: content review — Filesystem boundary gains
      the chain paragraph; Security scope names the writable outside
      path + --locked seal
      paths: README.md
- [x] docs: state the linked-worktree mount contract
      hash: 2924f62

- [x] Human validation — response: host `./bin/devbox -- --validate` all
      green — live, extended, static, agent-context, pi-state, parity
      (clean after package reconcile), PTY, cache, git identity/policy,
      parser/mount-plan, OpenCode integrity/preflight, skills-symlink;
      outcome: pass — "All devbox validation tests passed!" · surfaced:
      npm-cache-in-box follow-up candidate

### Verification receipts — in-box assembly smoke · 2026-11-16T16:19:22Z

- Stubbed-backend harness (fake `bwrap` + `pi`/`opencode` shims on PATH):
  real `bin/devbox` assembly captured across four launches, exit 0 each.
- rw default: `--bind` on common dir then gitdir (nested order), `--dir`
  parents for both chain ancestors; info lines name the chain and
  "Worktree git chain: writable" (verbose-gated, as designed).
- `--locked` and `--ro`: both chain paths flip to `--ro-bind`; policy
  line "read-only".
- Plain-repo control: zero chain binds, zero info lines.
- Surfaced finding (wrapper): in-box `git worktree add` dies — git
  re-invokes a bare `git reset --hard` through PATH and the wrapper
  carve-out only admits `reset --hard --no-recurse-submodules`.
  Creating worktrees in-box is git-version-dependent; consuming existing
  worktrees (this change's scope) is unaffected. → Human verdict:
  widen the carve-out or document host-side creation.
- Surfaced finding (environmental): repo-run of `bin/devbox` inside an
  active box conflicts on `/devbox/bin/{pi,opencode}` guard destinations
  (the box's own guards vs repo scripts — source disagreement);
  harness stubbed both shims. Host runs unaffected.
- Still Human-only: a real host launch at a linked worktree (interactive
  `status`/`diff`/`log`/`add`/`commit` green, `--locked` sealed) — nested
  bwrap cannot run in-box.

<!-- gate receipts land here while work runs; per-Slice H2s mirror the Plan's H3s -->
