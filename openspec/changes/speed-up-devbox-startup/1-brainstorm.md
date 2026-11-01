# Brainstorm

> Spec: speed-up-devbox-startup · why this exists

## Pain

Every `devbox` launch costs ~622ms wall on the reference host, and 595ms of
that is devbox's own pre-exec work before Bubblewrap even starts: 178ms
binding ~27 host runtime directories through per-item subprocess storms,
262ms assembling the Pi/integration/SSH/clipboard/Neovim/GUI tail, 78ms
building the environment, 29ms reading a 9-value cache through nine separate
`base64` forks, and 25ms of tool discovery that pays a full 619-line bash
interpreter spawn for an OpenCode preflight whose answer is already cached.
Interactive use feels the drag on every shell, every agent launch, every
scripted call, and none of it buys any policy strength — it is repeated
questions with full-price answers.

## Questions

- Q1 — What is the honest, reproducible measurement baseline and kit (host
  hyperfine + startup trace, in-sandbox forced-probe approximation), so every
  optimization lands with before/after receipts instead of vibes?
- Q2 — Which of the located costs are fork storms convertible to bash-native
  or batched calls without changing the assembled BWRAP argv (host-tool binds,
  cache read, env inheritance, Pi-closure path resolution)?
- Q3 — Which resolutions are machine-stable enough to live in the existing
  mtime-guarded discovery cache (host tool homes, git wrapper realpaths,
  integrity cache-hit answer) without weakening its security properties
  (inert data, owner-only, atomic writes, invalidation on script/bwrap
  change)?
- Q4 — What is the pi-parity fixture's actual store-mount defect, what is the
  minimal fixture-or-product fix, and does the fix restore the suite to fully
  green with no skip flag?

<!-- Direction (optional, free): hunch — the argv is sacred; every slice must
be provably argv-identical (or explicitly, test-flagged as a fixture fix).
Fork-count is the enemy: one batched call beats ten clever ones. The
discovery cache already owns the invalidation discipline — extend it, never
fork it. -->
