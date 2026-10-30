# Tasks

Step states: `[ ]` Pending, `[-]` Running/interrupted/failed, `[x]` Complete.

## Task 1 — Decide whether sandbox-exec can safely back macOS devbox

**Value:** The team has real-Mac evidence, one explicit feasibility decision, known parity gaps, and one recommended next Plan before production backend work begins.
**Method:** Spike
**Bounded question:** Can macOS `sandbox-exec` enforce target-scoped writes, outside-write and credential-read denial, temporary HOME/state, locked network denial, and symlink-safe path rules strongly enough for an honest native devbox backend?
**Timebox:** Maximum 3 hours total: up to 2 hours of temporary-directory-only local Mac probing and up to 1 hour of evidence synthesis.
**Decision criteria:** Return exactly `GO`, `CONDITIONAL GO`, or `NO-GO`. `GO` requires all minimum controls to pass on at least one identified Mac/macOS combination; `CONDITIONAL GO` requires bounded gaps plus a safe fail-closed product contract; `NO-GO` applies when a required control is unavailable or unreliable. Always list untested versions/architectures as residual risk.
**Final history target:** `docs(devbox): record macOS sandbox decision`
**Current Git boundary:** Planning artifacts only. The selected read-only Spike Step creates no source commit or fabricated checkpoint; Task-boundary history waits for Human validation.
**Human validation:** Pending

- [ ] Step 1.1 Assess sandbox-exec with bounded Mac evidence and decide.
  - Scope: Read `bin/devbox`, directly relevant tests/docs, local macOS CLI/help output, and a Mac developer's temporary-directory-only probe results. Do not edit source, tests, CI, or production behavior.
  - Evidence contract: Identify macOS version and architecture; record command, exit status, and discriminating observation for target write, outside-write denial, read-only target, temporary HOME non-persistence, credential-path denial without reading contents, symlink escape resistance, locked network denial, and unavailable/invalid-profile fail-closed behavior. Do not capture credentials or unrelated environment values.
  - Required output: Evidence table; Linux-versus-macOS guarantee differences; exactly one decision; residual risks; one recommended next Plan. No prototype promotion.
  - Timing: Pending; stop at the 3-hour cap.
  - Check: Pending — evidence completeness, discriminating failures, no sensitive values, no repository mutation, one decision, and one recommendation.
  - History: None for this read-only Step.

### Human validation

- [ ] Human confirms that the decision matches the Mac developer's observed evidence and returns `VALID`.
