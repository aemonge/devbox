# Plan: Restore global workflow resources inside devbox

**Idea:** `make-devbox-resources-visible`
**Method:** Fix

**Symptom:** A default writable devbox omits the host-readable Pi agent and Taskflow directories plus user OpenSpec schemas. The preserved pre-repair consumer probe returned exit 1 and reported all four representative paths absent, so the clean-project Happy-path cannot create its Idea, Plan, Task, or greeting.

**Cause:** `PI_AGENT_RO_PATHS` omits `agents` and `taskflows`, while `bind_pi_xdg_resources` mounts only Pi-specific XDG trees and never the narrow user OpenSpec schema data tree.

**Bounded repair:** Change only the devbox launcher and relevant devbox tests. Restore Pi agents and Taskflows read-only through existing symlink-safe bind helpers, and expose only the user OpenSpec schema directory read-only at its canonical sandbox XDG data destination. Retain destination-conflict failure, locked-mode restrictions, default Pi-config restrictions, and project-local OpenSpec precedence.

**Regression check:** Fixture-backed default and locked devboxes must read agents, Taskflows, symlink-backed variants, and user schemas but fail writes. Existing Pi extension/package and project-local OpenSpec checks must remain green; `bash -n`, focused devbox tests, and the complete available devbox validation suite must pass.

## Value

A plain `devbox pi` session targeting any project can discover Ramona's global agents and saved flows and resolve both Ramona user schemas without temporary `--add` mounts or `--allow-pi-config`.

## Acceptance criteria

- [ ] Default and `--locked` devboxes expose named Pi agents, Taskflows, and user OpenSpec schemas read-only, including symlink-backed Pi resource directories.
- [ ] The repair does not expose the complete XDG data tree and does not grant writes to agents, flows, or schemas.
- [ ] Existing package, extension, project-local OpenSpec precedence, Pi-config restrictions, sandbox security, and conflicting-destination fail-closed behavior remain intact.
- [ ] Shell syntax, focused devbox tests, and the complete available devbox validation suite pass.
- [ ] On the host, plain `devbox pi` discovers `ramona-happy-path`, resolves `ramona-idea` and `ramona-plan`, and completes the clean-project greeting consumer while private checkpoint and OpenSpec progress remain coherent and Human validation remains pending.

## Scope and boundaries

Included: `bin/devbox` and only relevant `bin/test/devbox-*` coverage, plus this Plan's OpenSpec progress. Excluded: `bin/spi`, unrelated version text, environment inheritance, OpenCode configuration, broad home/XDG mounts, tooling changes, and history rewriting. Existing unrelated `bin/updater` work must remain untouched.

If nested devbox cannot execute complete live validation, the implementation Step must stop safely as failed and report the exact remaining host command; it must not claim completion.

## Method and environment

Use the saved `ramona-fix` flow in mode `one` for Task 1 Step 1.1. Execution environment is a diagnosed writable `devbox`, evidenced by `/devbox` and a writable selected-target mount during flow preflight. The flow may be bootstrapped with explicit read-only resource mounts because the diagnosed defect hides the flow itself; those mounts are not part of final acceptance.

Final history target: `fix(devbox): restore global Pi and OpenSpec resources`. Successful Step history is a private checkpoint; Human alone may complete the Task boundary after validation.

## Verification

Automated: preserve the failing baseline; run `bash -n bin/devbox` and relevant static/parser/live tests, then every available `bin/test/devbox*-test` validation executable. Manual host validation uses plain `devbox pi` against a clean temporary project with no temporary mounts, confirms flow/schema discovery and exact greeting creation, then inspects checkpoint/OpenSpec coherence with Human validation still unchecked.
