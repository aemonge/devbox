# Plan: Characterize macOS sandbox-exec feasibility

**Idea:** `make-devbox-cross-platform`
**Method:** Spike

**Bounded question:** Can the built-in macOS `sandbox-exec`/Seatbelt mechanism enforce a minimum useful devbox contract—target-scoped writes, denied outside writes and credential reads, temporary HOME/state, locked network denial, and symlink-safe path rules—without pretending to provide Linux mount-namespace parity?

**Timebox:** At most 3 hours total: up to 2 hours for one or more Mac developers to run a temporary-directory-only local probe, then up to 1 hour to synthesize evidence and decide. Stop earlier when a decision criterion is conclusively met.

**Decision criteria:** Choose exactly one decision: `GO` when the minimum contract is discriminated and passes on at least one identified Mac/macOS combination; `CONDITIONAL GO` when it passes with explicit bounded gaps and a safe fail-closed product contract; or `NO-GO` when required controls cannot be enforced reliably. Record unsupported or untested Mac architectures/versions as residual risk rather than assuming parity.

## Value

The team gets evidence from a real Mac and one explicit decision about whether to build a native `sandbox-exec` backend, plus the smallest recommended next Plan. Linux implementation does not start from guessed Seatbelt semantics.

## Acceptance criteria

- [ ] Evidence identifies macOS version and architecture without collecting credentials or unrelated environment values.
- [ ] A bounded local probe records discriminating pass/fail outcomes for target writes, outside-write denial, read-only target behavior, temporary HOME non-persistence, credential-path denial, symlink escape resistance, and locked network denial.
- [ ] The report distinguishes access-control guarantees from Bubblewrap filesystem-namespace guarantees and lists parity gaps.
- [ ] The Spike returns exactly one `GO`, `CONDITIONAL GO`, or `NO-GO` decision with evidence, residual risks, and one recommended next action.
- [ ] No production source, tests, CI, or sandbox behavior are mutated or promoted from disposable investigation.

## Scope and boundaries

Included: read-only assessment of `bin/devbox`, relevant existing tests and documentation, local macOS CLI/help behavior, and Mac-developer evidence from temporary-directory-only probes. Excluded: production backend code, committed probe prototypes, Linux behavior changes, CI configuration, credential contents, unrelated session history, remote-system mutation, and claims about untested Mac versions.

The minimum contract may intentionally differ from Linux where Seatbelt cannot synthesize mounts, `/proc`, `/dev`, or a filesystem namespace. Any accepted difference must be explicit and fail closed. If `sandbox-exec` is unavailable, rejects the required profile, or permits a required denied action, preserve the evidence and decide accordingly rather than falling back to unsandboxed execution.

## Method and environment

Use `Spike`. Planning and synthesis currently run on a `host` Linux environment; this classification is descriptive, not a proven restriction. Behavioral evidence must come from an identified Mac host operated by a developer. Because no macOS devbox backend exists yet, the saved devbox-only `ramona-spike` flow is not selected; execute the eventual investigation directly as a bounded read-only synthesis over Human-supplied local probe evidence.

The investigation Step must not edit repository source. Read-only findings do not fabricate a source checkpoint. Final history target after Human accepts the decision: `docs(devbox): record macOS sandbox decision`.

## Verification

Review the evidence table for every decision criterion, ensure failed commands are discriminating rather than setup errors, confirm no sensitive values were captured, compare the decision with the stated minimum contract, and run strict OpenSpec validation. Human manually checks that the recommendation matches the Mac developer's observed results and returns `VALID`, `NOT VALID`, or `CHANGE: <problem>`.
