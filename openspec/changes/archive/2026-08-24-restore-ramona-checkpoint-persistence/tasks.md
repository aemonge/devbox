# Tasks

Step states: `[ ]` Pending, `[-]` Running/interrupted/failed, `[x]` Complete.

## Task 1 — Persist bounded Ramona checkpoints across devbox exit

**Value:** A normal writable devbox preserves Ramona's owner-only checkpoints for
recovery after exit without exposing unrelated XDG state.
**Method:** Fix
**Symptom:** Run `ramona-happy-path-mt6z05hc-3e91f0` created and verified a
checkpoint inside devbox and marked its Step complete, but the checkpoint was
absent from host state after exit.
**Cause:** `bind_pi_xdg_resources` binds only the `pi` XDG state namespace;
`$XDG_STATE_HOME/ramona` remains on disposable sandbox tmpfs.
**Bounded repair:** Persist only the Ramona XDG state namespace in normal modes,
keep it owner-only, leave locked mode ephemeral, and modify only `bin/devbox`,
directly relevant `bin/test/devbox-*` tests, and matching progress.
**Regression check:** Default write/exit/read persistence and exact bytes pass;
directories are `0700` and files `0600`; locked mode does not persist; custom XDG
state maps correctly; unrelated state stays hidden; Pi state and all devbox tests
remain green; and a fresh Happy-path checkpoint survives Pi exit.
**Final history target:** `fix(devbox): persist bounded Ramona checkpoints`
**Current Git boundary:**
`2e6c653 step(devbox): persist bounded Ramona checkpoints`; Human validation
permits the declared Task-boundary commit.
**Human validation:** `VALID` recorded 2026-08-24T09:14:58Z after direct host
inspection of exact bytes, modes, and manifest integrity.

- [x] Step 1.1 Add the narrow persistent Ramona state bind and discriminating
  regression coverage.
  - Timing: Started 2026-08-24T08:45:17Z; nested run blocked at
    2026-08-24T08:48:33Z; host retry completed 2026-08-24T08:54:26Z.
  - Paths: `bin/devbox`, directly relevant `bin/test/devbox-*`, and this progress
    record only.
  - Check: PASS — nested shell syntax, static policy, parser/mount-plan, and
    Markdown checks passed; nested live validation stopped on Bubblewrap ENOSPC.
    The exact host contract then passed default write/exit/read persistence,
    `0700`/`0600` permissions, fresh-box reads, locked ephemerality, custom XDG
    state, hidden unrelated state, existing Pi state, all seven devbox test
    executables, and complete `bin/devbox -- --validate`. The undeclared
    whole-file ShellCheck findings were pre-existing and not part of the Plan's
    retry-check allowlist. Fresh run `ramona-happy-path-mt70900o-430621` then
    completed; after Pi exited, the host and a second devbox verified its exact
    checkpoint bytes, `0700` directories, `0600` files, and manifest integrity.
  - History: `2e6c653 step(devbox): persist bounded Ramona checkpoints`.

### Human validation

- [x] Human confirmed host checkpoint persistence with `VALID` at
  2026-08-24T09:14:58Z.
