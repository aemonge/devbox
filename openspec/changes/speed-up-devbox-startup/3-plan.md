# Plan

> Spec: speed-up-devbox-startup · the contract for execution

## Estimate

~3 hours across seven slices, medium confidence. Bounded unknowns: the
integration-tail fork census (host-only, one command), and the pi-parity
product fix's blast radius (parser suite already covers the intended mount
semantics, so the net is real). Every slice carries a hyperfine receipt, so
a slice that fails to pay its way gets reverted, not argued.

## Skills

- `bash-defensive-patterns` — batched external calls, guards before effects,
  strict mode preserved; governs every edit in this change.
- bare otherwise — no other loaded skill matches deforking, cache schemas, or
  benchmark harnesses.

## Workflow

Direct defork, one block per slice, under an argv-equivalence discipline:
the assembled BWRAP argv must stay byte-identical for identical inputs
except the single sanctioned delta (empty-dir bind removal in Slice 2),
which is snapshot- and static-tested. Investigate's alternatives lost as
recorded there: Rust rewrite (violates the all-bash decision; forks are the
cost, not the interpreter), daemonizing (changes the security lifecycle),
whole-argv caching (stale sockets/PTY make it dangerous). Make- style
micro-benchmarks lost to hyperfine (installed, statistical, scripted).

## Slices

### Slice 0 — bench kit

- [ ] `just bench`: hyperfine scripted runs (parse-only, full path),
      `DEVBOX_TRACE_STARTUP=1` phase capture, PS4 fork census; results land
      in the execute ledger, never in CI
- [ ] Host baseline recorded: wall ms, phase ms, fork counts
- Commit `feat: add startup bench kit` + post-commit Human validation ask

### Slice 1 — pi-parity fixture: green baseline

- [ ] Host probe (Human-run, one command): print the Pi-closure binds for
      the fixture invocation
- [ ] Fix per probe: bind the resolved Pi entry chain instead of the script
      shim (product, test-flagged) or pin the resolved entry (fixture-only);
      parser-suite contract "does not mount only the fragile shim file" is
      the guide
- [ ] Suite green with NO skip flag on host
- Commit `fix: mount the resolved pi entry for shim launches` + post-commit
  Human validation ask

### Slice 2 — host-tool binds: retire the mkdir storm

- [ ] L429: `[[ -d ]]` guard replaces host `mkdir -p`; absent dirs are
      skipped, never materialized; argv delta snapshot-tested (removal of
      binds for non-existent paths only)
- [ ] Batch per-subpath resolution where forks remain
- [ ] hyperfine receipt: 178ms block before/after
- Commit `perf: stop materializing host runtime directories` + post-commit
  Human validation ask

### Slice 3 — Pi state prep + discovery cache batching

- [ ] L943: one batched `mkdir -p`, conditional chmods
- [ ] Cache read/write: one batched base64 per direction; inert-data,
      whitelisted-key, atomic, owner-only contract re-asserted in
      devbox-cache-test
- [ ] New cache keys for machine-stable homes (rustup/cargo/go/pyenv) with
      validation entries
- Commit `perf: batch pi state prep and discovery cache io` + post-commit
  Human validation ask

### Slice 4 — OpenCode preflight: inline the cache hit

- [ ] devbox reads the integrity cache-hit answer directly (same
      fingerprint/stat validation, no helper spawn on hit); helper spawns on
      miss/invalid only
- [ ] preflight suite extended for the inline path
- Commit `perf: inline opencode integrity cache hits` + post-commit Human
  validation ask

### Slice 5 — env assembly + integration tail defork

- [ ] Host fork census assigns the 262ms tail and 78ms assembly their per-
      call shares; top offenders deforked (ssh config copies, PTY discovery,
      clipboard scan, nvim runtime prep, per-var env forks)
- [ ] argv-equivalence asserted per edit
- Commit `perf: defork environment assembly and integrations` + post-commit
  Human validation ask

### Slice 6 — receipts and close

- [ ] Final hyperfine + trace vs slice-0 baseline in the ledger; README perf
      note (one paragraph, numbers, not promises)
- [ ] Full unskipped host `--validate` green
- Commit `docs: record startup optimization receipts` + post-commit Human
  validation ask

## Verification

- Deterministic, per slice: `just check` green; argv-equivalence snapshots;
  hyperfine before/after in the ledger; `bash -n` on touched files.
- Whole change: `just bench` final numbers vs baseline; host `--validate`
  fully green with NO skip flag; clean `git status`; the human-only act is
  the host bench + validate run and the verdict reply.

## History

- `feat: add startup bench kit`
- `fix: mount the resolved pi entry for shim launches`
- `perf: stop materializing host runtime directories`
- `perf: batch pi state prep and discovery cache io`
- `perf: inline opencode integrity cache hits`
- `perf: defork environment assembly and integrations`
- `docs: record startup optimization receipts`
