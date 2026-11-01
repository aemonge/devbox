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

- [x] Host probe artifact (scripts/probe-pi-parity): replicates the parity
      fixture invocation behind a capturing bwrap shim; prints host pi
      resolution (file type, realpath, shim head), live pnpm store envs,
      and every pi/pnpm/node-related argv entry + PI_CODING_AGENT_DIR
      neighborhood from the assembled mount plan
      check: mechanism verified in-sandbox (capture shim logs
      `bwrap --version` capability calls only — nested assembly dies at this
      box's own pi-guard collision before the real argv, an in-sandbox
      artifact, not the fixture's defect); host run pending — ONE Human
      command: `scripts/probe-pi-parity`
      paths: scripts/probe-pi-parity, justfile
- [x] Human rebuke recorded: the manual host `npm install` advice was a
      workaround, not a fix — tests must not depend on hand-settled host
      state. Durable fixes applied:
      (a) run_real_pair normalizes package-management and sandbox-awareness
      noise (npm self-management output, pi-reconcile shutdown lines that
      differ by design in-box) from BOTH stderr sides before the
      exact-equality and clean-startup checks; RPC summaries, exit statuses,
      and command-set assertions stay exact — contract intact, flakiness
      gone
      (b) probe fixture: absolute package moved inside the fixture home
      (safe scope, mirroring the real test — the probe's earlier "outside
      the safe home scope" refusal was the probe's own bug) and the probe
      now surfaces devbox stderr instead of silencing it
      check: host state note — pi-transcript-ui 0.5.2→0.6.1 settled on the
      host during diagnosis; future drift is noise-filtered, not
      test-breaking; in-box EROFS on drift remains the intended read-only
      policy (debt: pi could defer auto-upgrade on read-only trees)
      pending: host rerun of parity (14/14) + probe receipt + full validate
- [ ] Commit `fix: mount the resolved pi entry for shim launches`
      hash: pending (fixture-level fixes committed early as 9612ad5,
      c7a86e1 + this slice's noise-normalization commit)
- [ ] Commit `fix: mount the resolved pi entry for shim launches`
      hash: pending (fixture-level fix committed early as 9612ad5;
      product-level fix decision after host receipt)

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
