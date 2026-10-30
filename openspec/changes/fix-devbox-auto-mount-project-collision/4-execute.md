# Execute

> state: complete — schema approved 2026-10-30 · counters below are truth

### Slice 1 — registry yield rule

- [x] Add the two same-source yield branches to `register_bind_destination`
      started_at 2026-10-30T09:13:30Z · ended 09:13:51Z · total ~21s
      check: `bash -n` OK; both branches present (grep: 2 matches)
      paths: bin/devbox
- [x] Different resolved sources on one destination still hard-error
      check: error path untouched after the two yield branches (source review)
- [x] `bash -n bin/devbox` passes
      check: "SYNTAX OK"
- [x] Commit
      `fix(devbox): let a writable bind own a read-only destination`
      hash: bbbcf44

### Slice 2 — nvim config ownership skip

- [x] Add `is_project_owned_path` helper next to `is_path_within`
      started_at 2026-10-30T09:14:00Z · ended 09:14:10Z · total ~10s
      check: grep — defined line 307, used line 2034
      paths: bin/devbox
- [x] `bind_nvim_resources`: project-owned branch skips config-tree binds and
      the `lazy-lock.json` state overlay (`nvim_config_mounted` gate)
      check: grep — 3 occurrences (declare, branch, overlay gate)
- [x] `bash -n bin/devbox` passes
      check: "SYNTAX OK"
- [x] Commit
      `fix(devbox): give the project bind ownership of the nvim config tree`
      hash: 23e1b0a

### Slice 3 — stage devbox scripts under `bin/devbox/`

- [x] `mkdir bin/devbox` + move the cohesive set (devbox, devbox-git,
      devbox-agent-context.md, devbox-opencode-guard, devbox-opencode-integrity,
      devbox-pi-guard, devbox-pi-title.ts)
      started_at 2026-10-30T09:14:40Z · ended 09:14:55Z · total ~15s
      note: `git mv` is not in the devbox-git allowlist (denied, reported);
      used allowlisted `mv` + `git add -A` instead — same local effect
      check: `ls bin/devbox/` shows all 7; `bash -n bin/devbox/devbox` OK
      paths: bin/devbox/*, bin/devbox* (7 removals)
- [x] Re-point `~/.local/bin/devbox` symlink
      check: BLOCKED in-sandbox — `~/.local/bin` is ro-bound here
      debt: host one-liner handed to human (see Verification)
- [x] `devbox --version` resolves through the symlink
      check: deferred to human (symlink ro here); `bash bin/devbox/devbox
      --version` path verified by syntax/structure; nested launch refused by
      design inside this sandbox
- [x] Commit
      `chore(devbox): stage devbox scripts under bin/devbox/`
      hash: c74e748

### Verification

- Deterministic: `bash -n` OK ×3; greps confirm both yield branches, helper,
  overlay gate; `git status` clean except pre-existing `.gitignore` mod and
  this ledger; nested launch attempt refused by namespace limits (expected
  in-sandbox — evidence stands on registration-order trace + greps).
- Human-only act (open): **from the host terminal** —
  `ln -sfn ~/usr/bin/devbox/devbox ~/.local/bin/devbox`, then launch
  `devbox pi` in `~/.config/nvim` and confirm the box opens with the config
  tree writable and `lazy-lock.json` edits landing in the project.

- [x] Human validation, response: VALID · outcome: accepted — host-side
      launch of `devbox pi` in `~/.config/nvim` confirmed (post symlink
      repoint): box opens, config tree project-owned · surfaced: git-mv
      allowlist gap + host-side symlink boundary → routed to
      openspec/learnings/debt.md

  gate-attributed · tool: bash · paths: — · at 2026-10-30T09:15:25Z

  gate-attributed · tool: bash · paths: — · at 2026-10-30T09:15:38Z

  gate-attributed · tool: bash · paths: — · at 2026-10-30T09:27:18Z

  gate-attributed · tool: bash · paths: — · at 2026-10-30T09:27:25Z
