# Debt ledger

Routed here by changes when something surfaced that is real, worth keeping,
and out of the change's scope.

## vhs-render-in-sandbox — 2026-11-01 (scaffold-devbox-repo-tooling)

VHS cannot render in a nested devbox: headless Chrome exits before its
debugging endpoint is ready (`could not start browser`). `just record` is
therefore a host-side step; tapes ship in `tapes/*.tape` and render to
`tapes/out/` (gitignored). The doctor tape additionally shows the honest
namespace refusal when rendered in-sandbox versus the full suite on a host —
that difference is documented in the tape header.

## pi-parity-fixture-store-drift — 2026-11-01 (scaffold-devbox-repo-tooling)

`devbox-pi-parity-test` fails on the host with `MODULE_NOT_FOUND` for the real
Pi entry inside the fixture box: the fixture launches real Pi with
`PI_CODING_AGENT_DIR` pointed at the fixture root and `--no-host-tools`, and
the host pnpm global dir currently holds ~13 env dirs (several stale). The
resolved store env inside the fixture box (`3e4f681e…`) does not match the
package tree the closure mounts, so the entry is not visible in-box — while
validation A.3 (no `PI_CODING_AGENT_DIR` override) passes with the same
`--no-host-tools`. Store mounts for the resolved Pi binary need a look when
the fixture is repaired; `DEVBOX_SKIP_PI_PARITY=1` provides the honest skip.
Fix scheduled as the baseline slice of the speed-up change (green suite before
refactor). Host-only repro; nested boxes cannot launch the fixture sandbox.
