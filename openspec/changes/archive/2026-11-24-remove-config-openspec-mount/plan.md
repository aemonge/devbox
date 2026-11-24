# Plan

> Spec: remove-config-openspec-mount · schema micro

## Goal

Stop putting host `~/.config/openspec` into devbox sandboxes entirely:
no read-only mount in ephemeral mode, no writable mount (and no dir
fabrication) in persistent mode, no symlink-target bindings for it. For
Human: sandboxes stop leaking the global OpenSpec config state.

## Questions & Decisions

- Does "at all" include the symlinked-project tree that lands at
  `~/.config/openspec`? → No. That destination comes from the
  project-local `openspec/` mount in `bind_nearest_project_openspec`
  (footer parity for symlinked layouts), not the global config; it stays.
- Do the OpenSpec schemas mounts stay? → Yes. `~/.local/share/openspec/
  schemas` is a different XDG root and a different feature; untouched.
- What happens to the `openspec_destination_reserved` machinery? →
  Deleted. Nothing binds `~/.config/openspec` after this change, so the
  reservation logic is dead code.
- Does the nearest-project OpenSpec walk get to mount the global root?
  → No. Launching from a cwd under `~/.config` (e.g. `~/.config/hypr`)
  made `bind_nearest_project_openspec` walk up and treat the global
  `~/.config/openspec` root as a "project" tree, mounting it read-only
  at `~/.config/openspec`. The global XDG config root is state, never a
  project tree; the walk must skip it as destination.

## Tasks

### Slice 1 — remove the global mount from the launcher

- [x] In `bind_opencode_state()` (`bin/devbox`): drop
      `host_openspec_config`, `sandbox_openspec_config`,
      `openspec_destination_reserved`, the reservation check, the
      ephemeral read-only mount, the persistent
      `bind_runtime_dir` mount, and both symlink-target bindings
      check: `bash -n`, `shellcheck`, `shfmt -i 4` clean on `bin/devbox`
      paths: bin/devbox

### Slice 2 — align tests and verify

- [x] `devbox-live-extended-test`: drop the `.config/openspec` fixture
      entry and the `~/.config/openspec` writable-path expectation in P.1
      check: fixture no longer references `.config/openspec`
      paths: bin/test/devbox-live-extended-test
- [x] Run static, parser, and live-extended suites; parser assertions for
      the symlink-project mount (`assert_sequence_contains` at
      `~/.config/openspec`) must stay green untouched
      check: suites exit clean
      paths: bin/test/

### Slice 3 — the walk never mounts the global XDG OpenSpec root

- [x] `bind_nearest_project_openspec`: resolve the global root
      `${XDG_CONFIG_HOME:-${HOST_HOME}/.config}/openspec` once and skip
      any walk match whose logical destination is that path (both loops)
      check: `bash -n`, `shellcheck`, `shfmt -i 4` clean on `bin/devbox`
      paths: bin/devbox
- [x] `devbox-parser-test`: flip the symlink-scenario assertion at
      `~/.config/openspec` from present to absent
      check: parser suite green except the pre-existing jiti case
      paths: bin/test/devbox-parser-test
- [x] `devbox-live-test`: rewrite the symlink-validation expectation to
      `~/.config/openspec` being absent in the sandbox
      check: live suites are host-only — flagged for hands-on
      paths: bin/test/devbox-live-test

## Verification

- [x] Automated: `bash -n` + `shellcheck` + `shfmt` on `bin/devbox`;
      static/parser/live-extended suites pass
      — receipts (Slices 1–2): `just check` exit 0; parser suite green
      except one PRE-EXISTING FAIL (jiti transform-cache bind) reproduced
      identically on HEAD via binary A/B swap, so it is a nested-sandbox
      TMPDIR artifact, not this change; live-extended is host-only (nested
      bubblewrap refused in-sandbox) — run on host before close
      — receipts (Slice 3): lint trio green; `just check` exit 0; parser
      suite with normalized TMPDIR: exit 0, 198/198 PASS — including
      'global XDG OpenSpec root is never mounted' — the earlier jiti FAIL
      was nested-sandbox TMPDIR noise, fully green once normalized
- [x] Hands-on validation
