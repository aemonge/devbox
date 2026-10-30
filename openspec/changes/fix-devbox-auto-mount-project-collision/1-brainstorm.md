# Brainstorm

> Spec: fix-devbox-auto-mount-project-collision · why this exists

## Pain

Launching `devbox pi` with `~/.config/nvim` as the target aborts with
`conflicting mount policy for /home/aemonge/.config/nvim: --ro-bind|… versus
--bind|…`. The same crash hits any auto-mounted read-only resource path chosen
as a project target (`~/.config/openspec`, `~/.config/appa`, …), because the
resource auto-mount and the explicit project bind both claim the same sandbox
destination. Working on one's own editor/agent configuration inside the
sandbox — the natural way to use the box — is therefore impossible without
ceremony.

## Questions

- Which registration order do the resource mounts and the project (alias) bind
  actually run in, and do later bwrap mounts reliably shadow earlier ones on
  the same destination?
- When the writable project bind wins, does any surviving child mount from the
  resource layer (e.g. the nvim `lazy-lock.json` state overlay) silently divert
  edits away from the project?
- Which other auto-mounted roots collide the same way, and does one registry
  rule cover them all — or does nvim need special ownership handling?
- When must a ro-vs-bind conflict on one destination *stay* a hard error
  (different resolved sources)?

## Direction

Hunch: the registry should let an explicit writable bind of the *same resolved
source* own the destination in either order, while nvim resources additionally
need to yield whole-tree ownership (including the lockfile overlay) when the
config tree *is* the selected project.
