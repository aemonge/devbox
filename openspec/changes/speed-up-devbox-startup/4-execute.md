# Execute

> state: running — plan granted 2026-11-01T17:32:53Z · counters below are truth

### Slice 0 — bench kit

- [x] scripts/bench — hyperfine (parse-only, full path), phase trace, PS4
      fork census; nested-box aware (census/trace only in-sandbox, honestly
      labeled)
      check: shellcheck/shfmt clean; lint gate extended to scripts/bench;
      in-sandbox run delivers census (72 mkdir / 18 base64 / 9 chmod / 2 mv
      across 7,438 trace lines, 549ms traced span) and phase trace (ends at
      the honest namespace refusal); timing sections self-skip nested with
      an explicit label
      paths: scripts/bench, justfile
- [x] Baseline recorded (host, Human 2026-11-01): 622ms ±12 wall · 595ms
      pre-exec · host-tool binds 178ms · tail 262ms · assembly 78ms · cache
      read 29ms · discovery 25ms
      check: host numbers from the Human's hyperfine + trace paste; census
      fork classes confirmed in-sandbox (mkdir storm = 47× L429 runtime
      subpaths + ~20× L943 Pi state prep + tmp scaffolding)
- [x] Commit `feat: add startup bench kit`
      hash: pending

### Slice 1 — pi-parity fixture: green baseline

- [ ] Host probe artifact + Human-run receipt
      check: pending
- [ ] Fix (product or fixture per probe) + suite green, NO skip flag
      check: pending
- [ ] Commit `fix: mount the resolved pi entry for shim launches`
      hash: pending

### Slice 2 — host-tool binds: retire the mkdir storm

- [ ] L429 guard replaces host mkdir; argv delta snapshot-tested
      check: pending
- [ ] hyperfine receipt for the 178ms block
      check: pending
- [ ] Commit `perf: stop materializing host runtime directories`
      hash: pending

### Slice 3 — Pi state prep + discovery cache batching

- [ ] L943 batched mkdir/chmods; cache r/w one base64 per direction; stable
      homes cached with validation entries
      check: pending
- [ ] Commit `perf: batch pi state prep and discovery cache io`
      hash: pending

### Slice 4 — OpenCode preflight: inline the cache hit

- [ ] Inline cache-hit read; helper on miss/invalid only; preflight suite
      extended
      check: pending
- [ ] Commit `perf: inline opencode integrity cache hits`
      hash: pending

### Slice 5 — env assembly + integration tail defork

- [ ] Host census assigns the 262ms/78ms shares; top offenders deforked
      check: pending
- [ ] Commit `perf: defork environment assembly and integrations`
      hash: pending

### Slice 6 — receipts and close

- [ ] Final bench vs baseline in ledger; README perf paragraph; full
      unskipped host --validate green
      check: pending
- [ ] Commit `docs: record startup optimization receipts`
      hash: pending

### Verification

- pending — per slice: `just check`, argv snapshots, hyperfine receipts.
- Human-only act (open): host `just bench` + full unskipped `--validate` +
  verdict.

- [ ] Human validation, response: pending
