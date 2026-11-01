# Investigate

> Spec: speed-up-devbox-startup · answers the Brainstorm's Questions

## Findings

**Q1 — baseline and kit.** Host numbers (Human, 2026-11-01): 622ms ±12 wall
for `bin/devbox /bin/true -- /tmp -q` (10 runs), 9.7 MiB; phase trace:
parse/defaults ~23ms · discovery-cache init+read 29ms · tool discovery 25ms ·
host-tool binds 178ms · integration tail (Pi, GUI, SSH, project tools) 262ms ·
env+argv assembly 78ms · exec+child ~27ms. In-sandbox approximation exists but
is bounded: `DEVBOX_FORCE_PROBE=1` bypasses the cache read by design, and the
tail dies on a nested-box pi-guard collision — so host is the measurement
arena; in-sandbox runs prove logic, host runs prove milliseconds. Kit to add
in slice 0: `just bench` (hyperfine scripted runs + `DEVBOX_TRACE_STARTUP=1`
phase capture + PS4-line fork census), recorded in the ledger per slice.
`hyperfine` is installed; the PS4 technique is proven in this session's
traces.

**Q2 — the fork storms, counted.** PS4 census of a forced startup trace
(7,447 lines): 72 `mkdir` forks, 18 `base64`, 9 `chmod`, plus parse-bounded
bash-internal work — real time ≈ fork count × ~1.5–2ms.
Named offenders, line-verified in bin/devbox:

- L429 `bind_runtime_dir` runs `mkdir -p -- "${host_p}"` per runtime subpath —
  47 forks, AND a silent side effect: devbox materializes missing host
  directories (`~/.mix`, `~/.hex`, …) solely to bind them empty. Replacement:
  `[[ -d ]]` guard + precreated bind; absent dirs simply are not mounted.
  Argv delta: removal of empty-dir binds for never-existing paths only — to
  be snapshotted and static-suite-checked.
- L943 `prepare_pi_writable_state`: ~22 sequential mkdir/chmod forks (20
  state subdirs + trust + root, inside one umask subshell) → one batched
  `mkdir -p a b c…` + conditional chmods.
- Discovery cache r/w: 9 `base64` forks per direction (one per value) → one
  batched decode/encode per direction; values stay inert base64 data parsed
  by `read`, never eval'd (the static suite's security contract: whitelisted
  keys, inert encoding, atomic write, owner-only — all preserved).
- Tool discovery 25ms: `run_opencode_plugin_preflight` spawns the 619-line
  integrity helper per launch; on cache hit the helper only re-verifies the
  cache file — the cache-hit answer can be read directly by devbox (same
  stat/fingerprint validation, one jq-free bash path), spawning the helper
  only on miss or invalid state.
- Env+argv assembly 78ms: to be fork-censused on host in slice 0
  (`inherit_safe_environment` loop, `preserve_pi_session_environment`); the
  pattern suggests per-var command substitutions.
- Integration tail 262ms: named sub-suspects (SSH config copies, PTY
  discovery, clipboard socket scan, nvim runtime prep, Cargo/python in Pi
  packages) — host fork census in slice 0 assigns each its share before any
  edit.

**Q3 — what may be cached.** The discovery cache's guard is
`script-mtime + bwrap path/version + owner + mode 0600 + atomic write +
inert base64 values`. Machine-stable, policy-free resolutions are safe to
add under the same guard: host tool homes (rustup/cargo/go/pyenv roots),
git wrapper realpaths (already cached keys — the fork is the per-launch
re-validation `realpath`, cacheable as a validated snapshot), and the
OpenCode integrity cache-hit decision (bounded by watched-path mtimes the
helper already fingerprints). NOT cacheable: anything target- or env-
dependent (per-project binds, sockets, PTY), anything touching the security
contract. Cache schema stays whitelisted-key; new keys get new validation
entries in devbox-cache-test.

**Q4 — pi-parity defect.** Evidence: failing entry path is pnpm env
`3e4f681e…` while the live session runs from `1d4b-…`; both exist with
`cli.js` on the host; `~/.local/share/pnpm/bin/pi` is a POSIX-sh **script**
(not a symlink) that resolves its base directory from `$0` through
`node_modules/.bin` PATH logic. When devbox mounts the Pi closure, the shim
script is bound with exact-file fallback, and inside the box its `$0`-based
resolution runs against sandbox paths — the derived module root lands on a
store env whose tree the closure did not mount → `MODULE_NOT_FOUND`.
Consistent datapoint: validation A.3 (real Pi, `--no-host-tools`, no
`PI_CODING_AGENT_DIR` override) passes — the delta is the fixture's
`PI_CODING_AGENT_DIR` + independent-root closure, which changes what the
shim resolves against. Remaining unknown — which bind the closure *should*
make for the resolved entry — is answerable with one host probe (print the
Pi binds for the fixture invocation). Candidate fixes, in preference order:
(1) product: when Pi discovery resolves to a script shim, bind the shim's
resolved entry chain (node + real cli.js path) instead of the fragile shim
file — small, test-flagged behavior fix aligning with the parser suite's
"does not mount only the fragile shim file" intent; (2) fixture: resolve pi
host-side and pin the resolved entry. Decision lands in slice 0 with the
host probe receipt; suite must reach fully green, no skip flag.

## Verification instruments

- `just bench` (slice 0): hyperfine mean ±σ, phase trace, fork census —
  before/after per slice, recorded in the ledger.
- Argv equivalence: parser/capture mechanism extended where needed; every
  optimization slice asserts identical BWRAP argv for identical inputs
  (empty-dir-bind removal is the only sanctioned delta, snapshot-tested).
- `just check` green per slice; full host `--validate` (no skip flag) at
  close.
- Pi-parity: host probe receipt, then unskipped green run.

## Alternatives

1. Rewrite startup in Rust/C for speed. · Forks are the cost, not bash the
   interpreter; a rewrite violates the Human's all-bash decision and re-risks
   the validated policy. · Pick-when: never for this change.
2. Daemonize devbox (pre-warmed box pool). · Changes the lifecycle/security
   model entirely; out of scope, unbounded risk. · Pick-when: only if
   deforking plateaus above ~2× and interactive latency still hurts.
3. Cache the whole BWRAP argv per target. · Target/env-dependent state
   (sockets, PTY, mtimes) makes staleness dangerous; the policy lives in
   assembly. · Pick-when: never, except as per-block memoization inside the
   existing guarded discovery cache.
