# Plan: Restore restricted devbox file-descriptor compatibility

**Idea:** `preserve-bounded-devbox-unix-interfaces`
**Method:** Fix

**Symptom:** The host-level restricted-box canary `devbox bash -lc 'cmp -s <(printf x) <(printf x)' -- "$HOME/desktop/ramona-acceptance-host"` exits 2. Before source mutation, an outer check that itself used no process substitution confirmed `ABSENT:/dev/fd` inside the restricted box and exited 0; the process-substitution canary then exited 2.

**Cause:** Restricted devbox individually exposes selected device nodes but does not provide conventional `/dev/fd`, `/dev/stdin`, `/dev/stdout`, and `/dev/stderr` links expected by Bash process substitution and standard-stream paths.

**Bounded repair:** In restricted modes only, use Bubblewrap's own `--symlink` mechanism to provide `/dev/fd -> /proc/self/fd`, `/dev/stdin -> /proc/self/fd/0`, `/dev/stdout -> /proc/self/fd/1`, and `/dev/stderr -> /proc/self/fd/2`. Change only `bin/devbox`, directly relevant `bin/test/devbox-*` coverage, and matching OpenSpec progress. Do not bind the complete host `/dev` or alter unrelated launcher behavior.

**Regression check:** Restricted writable and locked modes must expose and correctly resolve all four links; Bash process substitution must succeed; full-dev must retain its existing `/dev` behavior; restricted mode must not broadly expose the host `/dev`; and existing selected device nodes must remain intact. `bash -n bin/devbox`, relevant static, parser, and live tests, every available `bin/test/devbox*-test`, and the complete `bin/devbox --validate` suite must pass. A nested namespace denial is discriminating failure evidence, never a pass.

## Value

Standard Bash process substitution and conventional standard-stream paths work in restricted devbox while the host `/dev` tree remains bounded.

## Acceptance criteria

- [x] Restricted writable mode exposes `/dev/fd` and Bash process substitution succeeds.
- [x] `/dev/stdin`, `/dev/stdout`, and `/dev/stderr` resolve to the current process's standard descriptors.
- [x] Locked mode retains the four compatibility links.
- [x] Full-dev behavior remains unchanged; restricted mode does not bind the complete host `/dev` and retains existing selected device nodes.
- [x] Shell syntax, relevant static/parser/live tests, every available devbox regression executable, and `bin/devbox --validate` pass.

## Scope and boundaries

Included: `/home/aemonge/usr/bin/devbox`, only directly relevant `/home/aemonge/usr/bin/test/devbox-*` regression coverage, and this Plan's OpenSpec progress/history. Excluded: unrelated version text, environment inheritance, credentials, OpenCode integration, other sandbox behavior, broad host `/dev` binding, and history rewriting.

The execution environment is `host` because `/devbox` is absent; this is descriptive, not a proven restriction. After repeated `ramona-fix` preflight blocks caused by the environment boundary, Human explicitly authorized this bounded Fix to execute directly on the host. This keeps source, live sandbox checks, OpenSpec progress, and Git history at one recoverable boundary without changing the repair scope.

## Method and environment

Method remains `Fix` for Task 1 Step 1.1. Before mutation, the host proved that a restricted box lacks `/dev/fd` and that process substitution exits 2. Human's explicit `OK` authorizes direct host delivery after the saved flow could not run under its devbox-only preflight; no wider Taskflow or delivery-method change is implied.

Final history target: `fix(devbox): restore restricted fd compatibility`. This is a Git worktree; successful Step history is `step(devbox): restore restricted fd compatibility`, recording only the bounded source/tests and matching OpenSpec progress. Human alone creates the conventional Task-boundary commit after validation and decides any history rewriting.

## Verification

Automated: preserve the absence and exit-2 baselines; run `bash -n bin/devbox`; focused static, parser, and live tests for restricted writable, locked, full-dev, bounded `/dev`, and existing device-node behavior; then every `bin/test/devbox*-test` executable and `bin/devbox --validate` from a normal host namespace.

Manual host validation runs the exact process-substitution canary against `$HOME/desktop/ramona-acceptance-host`, checks each compatibility link, and confirms Human validation remains pending until Human returns `VALID`.
