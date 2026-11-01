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
