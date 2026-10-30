# Plan

> Spec: fix-devbox-auto-mount-project-collision · the contract for execution

## Estimate

`openspec/learnings/estimation.md` does not exist yet — fresh estimate. Range
**25–50 minutes** of execution (all edits already composed verbatim; move +
symlink repoint + verification dominate). Confidence **0.85**; pinned at
commit time.

## Skills

`bare — plain Bash plus the bwrap mount-order semantics already established in
the Investigate findings; no project skill articles exist for this codebase.`

## Workflow

The committed route is the **composite** the Findings support: a registry
yield rule (same resolved source + same destination → writable bind owns it,
either registration order) **plus** an nvim ownership skip (when the config
tree *is* the selected project, resource mounts and the lockfile overlay step
aside). Alternative 1 loses as a standalone route: it fixes nvim only and
leaves the identical crash on every other auto-mounted root. Alternative 2
loses because path-prefix ownership changes semantics for legitimate child
ro-mounts under the project root; exact-destination matching carries none of
that risk. The composite keeps each rule at the narrowest point that still
covers the whole bug class.

## Slices

### Slice 1 — registry yield rule

Commit: `fix(devbox): let a writable bind own a read-only destination`

- [ ] Add the two same-source yield branches to `register_bind_destination`
      (ro-yields-to-existing-bind: skip; bind-takes-over-existing-ro: upgrade
      policy and append, later bwrap mount shadows the earlier ro entry)
- [ ] Different resolved sources on one destination still hard-error
- [ ] `bash -n bin/devbox` passes

Human validation (post-commit): none beyond the change-level act below.

### Slice 2 — nvim config ownership skip

Commit: `fix(devbox): give the project bind ownership of the nvim config tree`

- [ ] Add `is_project_owned_path` helper (exact match on
      `SANDBOX_PROJECT_ROOT` / `PROJECT_ALIAS_DIR`) next to `is_path_within`
- [ ] `bind_nvim_resources`: project-owned branch skips config-tree binds and
      the `lazy-lock.json` state overlay (`nvim_config_mounted` gate); data/
      state/cache mounts unchanged
- [ ] `bash -n bin/devbox` passes

Human validation (post-commit): none beyond the change-level act below.

### Slice 3 — stage devbox scripts under `bin/devbox/`

Commit: `chore(devbox): stage devbox scripts under bin/devbox/`

- [ ] `mkdir bin/devbox` + `git mv` the cohesive set: `devbox`, `devbox-git`,
      `devbox-agent-context.md`, `devbox-opencode-guard`,
      `devbox-opencode-integrity`, `devbox-pi-guard`, `devbox-pi-title.ts`
      (all resolved via `SCRIPT_DIR`, so they stay cohesive)
- [ ] Re-point `~/.local/bin/devbox → ~/usr/bin/devbox/devbox` if writable
      from the sandbox; otherwise hand the one-liner to the human
- [ ] `devbox --version` resolves through the symlink

Human validation (post-commit): none beyond the change-level act below.

## Verification

Deterministic: `bash -n bin/devbox`; `devbox --version` via the symlink;
`git status` shows only the intended moves/edits; grep confirms the two yield
branches, the ownership helper, and the overlay gate; nested launch attempts
`devbox true -- ~/.config/nvim` and `devbox true -- ~/.config/openspec` from
inside this sandbox (if nested bwrap refuses, source-order trace stands as
evidence). Human-only act: **launch `devbox pi` in `~/.config/nvim` from the
host terminal** and confirm the box opens with the config tree writable and
`lazy-lock.json` edits landing in the project.

## History

Evidence-as-of-date 2026-10-30: registration order and bwrap shadowing traced
in `bin/devbox` lines ~330, ~1988-2063, ~3360-3481, ~3546-3554, ~3695-3715;
commit hashes to land in `4-execute.md`.
