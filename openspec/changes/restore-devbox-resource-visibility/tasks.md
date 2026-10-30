# Tasks

Step states: `[ ]` Pending, `[-]` Running/interrupted/failed, `[x]` Complete.

## Task 1 — Make global Ramona resources usable in a normal devbox

**Value:** A plain default `devbox pi` can use global Ramona agents, saved Taskflows, and user OpenSpec schemas while those resources remain read-only and project-local OpenSpec keeps precedence.
**Method:** Fix
**Symptom:** The preserved pre-repair default-devbox probe exited 1 and reported these host-readable paths absent: `~/.pi/agent/taskflows/ramona-happy-path.json`, `~/.pi/agent/agents/ramona-step-engineer.md`, and both user Ramona schema YAML files. The positive clean-project Happy-path therefore blocks before creating its Idea, Plan, Task, or greeting.
**Cause:** `PI_AGENT_RO_PATHS` excludes `agents` and `taskflows`; `bind_pi_xdg_resources` does not narrowly bind the user OpenSpec schema data directory.
**Bounded repair:** Modify only `bin/devbox` and relevant `bin/test/devbox-*` tests. Use existing safe, symlink-resolving, conflicting-destination-aware helpers to mount Pi agents, Taskflows, and only user OpenSpec schemas read-only. Preserve locked/default Pi-config policy, project-local precedence, and all unrelated behavior.
**Regression check:** Fixture tests must discriminate missing, writable, symlink-broken, broad-XDG, locked-mode, conflict-policy, package/extension, and project-local precedence regressions. `bash -n`, focused devbox tests, and every available devbox validation executable must pass. If complete live validation cannot run nested, stop failed and report the exact host command instead of completing this Step.
**Final history target:** `fix(devbox): restore global Pi and OpenSpec resources`
**Current non-Git boundary:** Private checkpoint `restore-devbox-resource-visibility/step-1.1`; Git Task-boundary history waits for Human validation.
**Human validation:** Pending

- [-] Step 1.1 Restore narrow read-only resources and prove the complete bounded repair.
  - Started: 2026-08-21T11:02:01Z
  - Selected flow: `ramona-fix`, mode `one`, change `restore-devbox-resource-visibility`, Task `1`, Step `1.1`, second Step `none`.
  - Paths: `bin/devbox`, only relevant `bin/test/devbox-*`, and matching progress in `openspec/changes/restore-devbox-resource-visibility/tasks.md`.
  - Baseline evidence: Before source mutation, a default devbox read probe printed `ABSENT` for the representative agent, Taskflow, `ramona-idea`, and `ramona-plan` files and exited `1`.
  - Required check: `bash -n bin/devbox`; focused static/parser/live devbox coverage for default, symlink-backed, read-only, locked, package/extension, user-schema, project-local precedence, and destination-conflict behavior; then `for test in bin/test/devbox*-test; do "$test"; done` for the complete available suite.
  - Timing: Failed at 2026-08-21T11:05:30Z after 3m29s (started 2026-08-21T11:02:01Z).
  - Check: `bash -n bin/devbox`, `bin/test/devbox-static-test`, and `bin/test/devbox-parser-test` passed. `bin/test/devbox-live-test` failed because the nested devbox cannot pass its Bubblewrap namespace probe (`Test 0.2`), so live coverage was skipped and the complete suite was not run. Retry on the host with exactly: `cd /home/aemonge/usr && bash -lc 'set -euo pipefail; bash -n bin/devbox; for test in bin/test/devbox*-test; do "$test"; done'`.
  - History: Failed state preserved in `error(devbox): preserve fix pending host validation`; no private checkpoint was created.

### Human validation

- [ ] Human runs the host acceptance with plain `devbox pi`, confirms `ramona-happy-path` discovery, both schema resolutions, a clean-project Happy-path-created `greeting.txt` containing exactly `Hello from Ramona!\n`, coherent private checkpoint/OpenSpec progress, and then returns `VALID`.
