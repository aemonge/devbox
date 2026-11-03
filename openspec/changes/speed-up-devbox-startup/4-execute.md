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
- [x] Suite green, NO skip flag — HOST RECEIPTS 2026-11-01: parity 18/18
      (incl. both real-Pi RPC pairs, Fancy Footer parity, runtime hash
      parity), full `bin/devbox -- --validate` 🎉 with every suite green
      (live, extended, static, parser, git-policy, integrity, preflight,
      pi-state, agent-context, cache, pty, git-identity, skills-symlink)
- [x] Slice-1 commits (declared name evolved into a fix series, recorded
      honestly): 9612ad5 `fix: authorize the pnpm root in the pi-parity
      fixture` · c7a86e1 `test: surface devbox errors in the pi-parity
      probe` · 7f80f49 `fix: normalize environment noise in pi parity
      stderr checks` · 1e4b034 `fix: decouple pi parity assertions from
      host focus state`
- [x] Assurance receipts (Human-requested): whitespace-ignored diff of
      bin/devbox vs pre-session baseline 600a084 shows ONLY the 0.1.0→0.2.0
      usage doc string, the skills-symlink X-loop wiring, and reviewed
      shfmt line-structure classes; all four guard scripts have ZERO
      changed lines; every test change classified as (a) new coverage
      (32 bats + adopted ~1,100-assertion suite + skills wiring),
      (b) stale-assertion alignment to already-validated policy (yield rule
      bbbcf44, nvim overlay gate — each was failing against the current
      code before its fix), (c) environment-coupling normalization with the
      parity contract itself intact (summary equality still exact),
      (d) diagnostics (probe, bench) outside the gates
- [x] Commit `fix: mount the resolved pi entry for shim launches`
      hash: superseded by the fix series — product-level fix NOT needed;
      decision recorded: the closure mounting semantics were correct, the
      fixture simply under-authorized its pnpm root (9612ad5 authorized it,
      parity 18/18 green, no skip flag). The fragile-shim-file contract
      ("does not mount only the shim") was never violated by the product;
      no bin/devbox change required

### Slice 2 — host-tool binds: retire the mkdir storm

- [x] L429 guard replaces host mkdir; absent dirs skipped, never
      materialized
      check: `bind_runtime_dir` now returns 0 for absent host dirs; the
      snapshot discipline surfaced TWO feature-required creation sites that
      implicit mkdir was silently carrying — OpenCode config/data/state/
      cache and the devbox opencode integrity-cache dir — now explicit via
      `bind_runtime_dir_created` (deliberate host mkdir, 5 forks, feature
      persistence preserved); parser 195/195 after each step; static 138,
      integrity 46, preflight 10, skills 19, agent-context 12, cache 6,
      git-identity 3, git-policy green; `just check` green
      paths: bin/devbox
- [x] Fork receipt (in-sandbox census, forced probe): mkdir 72 → 31 per
      launch (−41 forks); traced span 549ms → 445ms under tracing
      inflation; host millisecond receipt pending next `just bench`
- [x] HOST RECEIPT (Human, 2026-11-01): full startup 502.3ms ±8.9 (baseline
      622ms → −120ms, −19%); parse-only 19.0ms; host-tool binds 178→100ms;
      tail 262→208ms; fork census on host: mkdir 30, base64 18, chmod 9
- [x] Commit `perf: stop materializing host runtime directories`
      hash: 7895473 — SUPERSEDED in part: see the regression entry below
      (skip-if-absent was wrong for provisioned tool state; batched
      provisioning keeps the fork win and the feature)
- [x] REGRESSION CAUGHT BY HOST VALIDATION (D.1b) and fixed: skip-if-absent
      broke a documented feature — runtime subpaths are PROVISIONED writable
      tool-cache state (live test D.1b "devbox-parity host tool state is
      writable"); a fresh fixture home must get its ~/.cache/uv created and
      bound. Fix: bind_runtime_dir restored to create-on-demand; the
      27-subpath loop now provisions absent dirs in ONE batched mkdir then
      binds in original loop order (identical argv, 27 mkdir forks → 1)
      check: parser 195/195, static 138/138, `just check` green; pending:
      host D.1b green on next validate
      lesson recorded: the mkdir was provisioning, not waste — the fork
      count was the only legitimate target
      paths: bin/devbox
- [x] Commit `fix: provision runtime cache dirs with one batched mkdir`
      hash: 831dbaf
- [x] Cache-poisoning bug found by the receipt and fixed: forced-probe runs
      (bench census, validation sub-invocations) skipped the cache READ but
      still WROTE the cache — dropping the namespace-ok stamp and taxing
      every real launch +52ms re-probe. Fix: write_discovery_cache returns
      early under DEVBOX_FORCE_PROBE/DEVBOX_FORCE_DISCOVERY (symmetry with
      the read skip); bench census additionally runs under an isolated HOME
      so it can never touch the real cache either way
      check: devbox-cache-test 6/6; `just check` green
      paths: bin/devbox, scripts/bench
- [x] Commit `perf: stop forced-probe runs from poisoning the discovery cache`
      hash: 8017e85

### Slice 3 — Pi state prep + discovery cache batching

- [x] L943 Pi state prep: 21 sequential mkdir forks → one batched
      `mkdir -p -- "${dirs[@]}"`; chmods collapsed (independent root+trust
      one call, portable trust another)
      check: pi-state-test 20/20 (state isolation contract intact);
      parser 195/195; static 138; `just check` green
      paths: bin/devbox
- [x] Cache IO: read path was already batched by the legacy suite (one
      base64 decode with the Cg== join); write path (9 forks) left as-is —
      it fires only on invalidation, not per launch; recorded as no-op
- [x] Stable-home caching: SKIPPED with evidence — select_host_tool_home
      and resolve_bind_source_path are bash-native (forks only for symlink
      realpath); nothing to cache; recorded as no-op
- [x] Fork receipt (in-sandbox census, isolated HOME): mkdir 30 → 10 (all
      remaining are intentional creations), base64 → 0 in forced runs, chmod
      9 → 6, traced span 445ms → 354ms
- [x] Commit `perf: batch pi state preparation and cache io forks`
      hash: eef804f

### Slice 4 — OpenCode preflight: evaluate-and-reject (recorded)

- [x] Measured: the helper spawn taxes only `devbox opencode …` launches
      (~20ms each), not every launch — run_opencode_plugin_preflight
      returns 0 for all other commands
      check: inlining the fingerprint logic would duplicate security-
      critical code with silent-divergence risk against the 46-test
      integrity suite; a background-and-wait pattern complicates the
      critical path for a subset-of-launches win. Rejected with receipts —
      revisit only if opencode launch latency becomes a measured complaint
      paths: none (decision record)

### Slice 4b — bench per-phase fork attribution (Slice 5 instrument)

- [x] scripts/bench census now attributes fork classes to phase windows
      (trace_startup labels), so the host run names the 208ms tail's
      offenders directly
      check: in-sandbox attribution works (defaults 3, discovery 4,
      binds-window 14 forks — the tail itself is host-only)
      paths: scripts/bench
- [x] Commit `feat: attribute bench forks per phase`
      hash: a273b5f

### Slice 4 — OpenCode preflight: inline the cache hit (CLOSED rejected)

- [x] Plan-vintage items closed by decision — the evaluate-and-reject above
      is the verdict; `perf: inline opencode integrity cache hits` is never
      committed by intent, not omission

### Slice 5 — env assembly + integration tail: profiled verdict

- [x] Host profile receipt (Human, 166cf07): tail = 186ms with ONE fork —
      the remaining tail cost is bash interpreter work (thousands of
      validation operations across the Pi closure and integrations), not
      forks; hot-lines named one safe offender: the stale editor-runtime
      prune paid id/stat/process_start_time/rm forks PER candidate
      check: prune hoisted `id -u` (once per launch, not per candidate),
      stale removals batched into one `rm -rf`; "stale editor runtime is
      pruned after its exact creating process exits" still green (parser
      195/195); `just check` green
      verdict recorded: remaining tail cost is the price of adversarial
      policy validation — further reduction belongs to the modularize
      change (per-module measurement with unit tests), not micro-edits
      paths: bin/devbox
- [x] Commit `perf: batch stale runtime pruning`
      hash: 898542e

### Slice 6 — receipts and close

- [x] Final numbers (host, 2026-11-01): full startup 474.9ms ±13.7
      (baseline 622ms → −147ms, −24%); parse-only 18.8ms; namespace +
      capability cache hits healed (7ms + 21ms); fork census mkdir 72 → 10
- [x] README Performance section added (honest numbers, `just bench`
      pointer)
      paths: README.md
- [x] Host validate receipt (2026-11-03): every suite green — live,
      extended, static, parser, integrity, preflight, pi-state,
      agent-context, cache, pty, git-identity, git-policy,
      skills-symlink — D.1b provisioning receipt settled; pi-parity
      FAILED: summarize_rpc crashed json.loads on a non-JSON stdout line
      check: in-box reproduction of the host rpc probe isolated the
      offender — `[pi-reconcile] session_shutdown reason=quit` on rpc
      stdout, new since the green 2026-11-01 run (host extension drift);
      the stderr side was already filtered by normalize_stderr
- [x] Fix: summarize_rpc tolerates the exact-prefix reconcile diagnostic
      (mirrors the stderr filter); fixture extended with the line;
      shipped block verified — fixture summary byte-exact, malformed
      output still fails closed, real-shaped output parses;
      shellcheck + shfmt -i 4 clean
      paths: bin/test/devbox-pi-parity-test
- [x] Phase trace receipt (2026-11-03, real caches): 432ms pre-exec
      (discovery 19 · capability 16 · namespace 6 · tool discovery 21 ·
      host tool binds 88 · runtime/GUI/SSH/project binds 200 · argv
      build 82); census traced 13,811 lines vs 7,438 at slice 0 —
      tracing inflation plus accumulated stale-editor-runtime prune
      candidates, so shares not absolutes; hyperfine absent from PATH
      this run — wall receipt pending the rerun bench
- [ ] Human-only act: host `bin/devbox -- --validate` (full suite) +
      `just bench` + verdict
- [ ] Commit `docs: record startup optimization receipts`
      hash: pending

### Verification

- pending — per slice: `just check`, argv snapshots, hyperfine receipts.
- Human-only act (open): host `just bench` + full unskipped `--validate` +
  verdict.

- [ ] Human validation, response: pending

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:28:32Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:29:18Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:29:45Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:29:53Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:37:15Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:37:25Z

  gate-attributed · tool: edit · paths: /home/aemonge/projects/devbox/bin/test/devbox-pi-parity-test · at 2026-11-03T13:39:07Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:39:14Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:39:25Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:40:01Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:40:20Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:40:46Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:41:05Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:41:23Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:41:44Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T13:42:26Z
