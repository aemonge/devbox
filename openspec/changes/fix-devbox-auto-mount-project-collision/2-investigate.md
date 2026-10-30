# Investigate

> Spec: fix-devbox-auto-mount-project-collision · answers the Brainstorm's Questions

## Findings

**Q1 — registration order & bwrap shadowing.** All resource and alias mounts
funnel through `register_bind_destination` (bin/devbox ~330), which keys
`EXTRA_BIND_DEST_SET` by sandbox destination and hard-errors on any policy
mismatch. For the repro (`devbox pi` in `~/.config/nvim`, a host symlink into
`~/galactica/.config/nvim`): `bind_nvim_resources` runs at line 3481 and
registers `--ro-bind galactica/.config/nvim → ~/.config/nvim`; the project
alias bind at line 3554 then registers `--bind` with the *same resolved host
and destination* → fatal. `BWRAP_CMD` appends `EXTRA_BINDS` (3699) before the
direct primary project bind (3700) and `SAFE_BINDS` (3715); bwrap applies
mounts in argv order, so a later `--bind` on the same destination shadows the
earlier `--ro-bind`. Both orderings are therefore safe to resolve in favor of
the writable bind.

**Q2 — surviving child mounts.** A child mount already applied survives a
later parent overmount (mounts stack per mountpoint). `bind_nvim_resources`
mounts a writable `lazy-lock.json` overlay at
`${sandbox_nvim_config}/lazy-lock.json` backed by
`~/.local/state/devbox/nvim/lazy-lock.json` (~2055-2063). If the config tree
becomes the writable project, that overlay would keep diverting lockfile edits
into devbox state — the tree must be owned wholesale, not just re-bound at the
root.

**Q3 — blast radius.** Other auto-mounted config roots (`~/.config/openspec`,
`~/.config/appa`, `~/.config/opencode` via `opt_ro_bind_dir`) hit only the
same-dest root pattern (no child overlays inside those trees), so one registry
rule covers them. nvim uniquely needs an ownership skip because of the
lockfile overlay. `SANDBOX_PROJECT_ROOT`/`PROJECT_ALIAS_DIR` are set at
~3368-3378, before `bind_nvim_resources` (3481) — the helper can see project
ownership. `--ro` runs stay dedup-safe (identical `--ro-bind` policy strings).
No symlinks exist anywhere inside `~/.config/nvim` (checked), so
`bind_symlink_targets_in_dir` contributes nothing for this repro.

**Q4 — when to stay a hard error.** Different resolved sources feeding one
sandbox destination is genuine ambiguity (which host tree is the truth?) and
must keep aborting. Same resolved source with mixed flags is not ambiguity:
the writable bind is the strictly stronger, explicitly chosen mount.

## Verification instruments

- `bash -n bin/devbox` after the edit.
- Launch attempts `devbox true -- ~/.config/nvim` and
  `devbox true -- ~/.config/openspec` (nested bwrap may refuse inside this
  sandbox; then source-order review + registration trace stand as evidence).
- Regression probe: ordinary target (`~/usr`) keeps its resource mounts ro.

## Alternatives

1. Teach only `bind_nvim_resources` project ownership, registry untouched.
   · Leaves the identical crash for every other auto-mounted root as target. ·
   Pick-when: never — the bug class is generic, the nvim case is one instance.
2. Global "project tree wins" by path prefix inside `add_*_bind_once`. ·
   Changes semantics for legitimate child ro-mounts under the project root
   (e.g. `-a` adds); riskier than exact-destination matching. · Pick-when:
   only if exact-destination rules prove insufficient in practice.
