# Tasks

Step states: `[ ]` Pending, `[-]` Running/interrupted/failed, `[x]` Complete.

## Task 1 — Restore conventional file-descriptor paths in restricted devbox

**Value:** Standard Bash process substitution and conventional standard-stream paths work in restricted writable and locked devboxes without broadly exposing host `/dev`.
**Method:** Fix
**Symptom:** Before source mutation, the restricted absence probe printed `ABSENT:/dev/fd` and exited 0 while the exact host-level process-substitution canary exited 2.
**Cause:** Restricted mode binds selected device nodes but omits `/dev/fd`, `/dev/stdin`, `/dev/stdout`, and `/dev/stderr` compatibility links.
**Bounded repair:** Use only Bubblewrap `--symlink` entries in restricted modes for `/proc/self/fd` and descriptors 0, 1, and 2; modify only `bin/devbox`, directly relevant `bin/test/devbox-*` tests, and matching OpenSpec progress. Do not bind complete host `/dev` or alter unrelated behavior.
**Regression check:** Restricted writable and locked modes expose and resolve all four links; process substitution succeeds; full-dev stays unchanged; restricted host `/dev` remains bounded; existing device nodes remain; `bash -n`, relevant static/parser/live tests, every available `bin/test/devbox*-test`, and `bin/devbox --validate` pass. Namespace denial is a failed check, not a skip-to-green.
**Final history target:** `fix(devbox): restore restricted fd compatibility`
**Current Git boundary:** Step history is `d7b6ca4 step(devbox): restore restricted fd compatibility`; accepted Task boundary is `fix(devbox): restore restricted fd compatibility`.
**Human validation:** VALID at 2026-08-24T08:11:47Z

- [x] Step 1.1 Add bounded Bubblewrap compatibility links and prove restricted, locked, and full-dev behavior.
  - Started: 2026-08-24T07:56:12Z.
  - Completed: 2026-08-24T08:02:53Z; elapsed 6m41s.
  - Delivery: Direct host Fix explicitly authorized by Human after `ramona-fix` preflight runs `ramona-fix-mt6vm9sa-bac730` and `ramona-fix-mt6w239g-bddb8b` blocked before implementation; original selection was mode `one`, change `restore-restricted-devbox-fd-compatibility`, Task `1`, Step `1.1`, second Step `none`.
  - Paths: `bin/devbox`, only directly relevant `bin/test/devbox-*`, and matching progress in `openspec/changes/restore-restricted-devbox-fd-compatibility/tasks.md`.
  - Baseline evidence: At 2026-08-24 before source mutation, an outer check using no process substitution printed `ABSENT:/dev/fd` from a restricted box and exited 0 in 3543ms; the exact process-substitution canary exited 2 in 1277ms.
  - Required check: `bash -n bin/devbox`; focused static/parser/live coverage for restricted writable links, process substitution, standard streams, locked links, unchanged full-dev, bounded host `/dev`, and existing device nodes; every available `bin/test/devbox*-test`; and complete `bin/devbox --validate`.
  - Timing: Complete in 6m41s.
  - Check: PASS — `bash -n` for the launcher and changed tests; focused static/parser/live tests; exact host process-substitution canary (exit 0 in 1414ms); restricted and locked link/device/bounded-`/dev` checks; unchanged full-dev live check; all seven `bin/test/devbox*-test` executables (82403ms); complete `bin/devbox -- --validate` (91446ms); strict validation for both linked OpenSpec changes.
  - History: `step(devbox): restore restricted fd compatibility` records only `bin/devbox`, directly relevant devbox tests, the linked Idea, and matching Fix Plan progress.

### Human validation

- [x] Human ran the host acceptance, confirmed exact process substitution plus all four compatibility links in restricted and locked modes without broad `/dev`, and returned `VALID` at 2026-08-24T08:11:47Z. Login-shell `tty` warnings were observed and accepted; the chained acceptance commands completed successfully.
