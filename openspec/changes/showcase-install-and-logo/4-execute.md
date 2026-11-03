# Execute

> state: running — plan granted 2026-11-03 · counters below are truth

### Slice 1 — installer remote mode + logo + contract tests

- [x] install.sh remote mode: piped-invocation detection (BASH_SOURCE
      unusable under `curl | bash`) plus explicit `--remote`; fetches
      main.tar.gz with curl (fallback wget) into a staging mktemp dir,
      REPO_ROOT points at the extraction, trap-cleanup on exit;
      --symlink + remote refused with a clear diagnostic; fetch-tool
      check in remote mode only
      check: bash -n, shellcheck, shfmt -i 4 clean
      paths: install.sh
- [x] Logo: persisted to ${PREFIX}/share/devbox/logo.png, displayed
      best-effort (chafa → kitten icat → path print); display failure
      can never fail the install
      paths: install.sh
- [x] Remote smoke (in-box, 2026-11-03): anonymous tarball fetch +
      extract + 7 scripts installed + verify OK — ALSO the hard evidence
      that the repo is public. The fetched tree lacked logo.png because
      origin/main is 6 commits behind local and logo.png was untracked —
      installer skipped it gracefully (best-effort by design); fixed by
      tracking logo.png in slice 2
- [x] Repo-mode smoke (in-box): install into /tmp prefix — 7 bin files,
      logo persisted, chafa rendered the logo live, verify OK
- [x] Contract tests: 9 installer assertions in the static suite
      (tarball URL, piped detection, curl/wget fallback, symlink
      refusal, staging cleanup, logo persistence + fallback order);
      static suite green
      paths: bin/test/devbox-static-test
- [x] Commit `feat: install devbox without cloning the repository`
      hash: c7e0a10

### Slice 2 — README face

- [x] Logo header at top; Install section leads with the curl one-liner
      (remote first, clone second); Showcase section embeds
      tapes/out/install.gif; logo.png now tracked so GitHub renders it
- [x] Commit `docs: lead with the logo and the no-clone install`
      hash: 1128227

### Slice 3 — showcase tape

- [x] tapes/install.tape (house style): throwaway demo HOME wiped at
      start (fixed /tmp path), the real curl one-liner, logo landing via
      chafa, `devbox --version` + `--help`
      paths: tapes/install.tape
- [x] Commit `docs: add the install showcase tape`
      hash: a01dc26 (receipts commit: 64723bb)
- [x] Host render receipt (2026-11-03): vhs parser dialect fixed (no
      escaped quotes in Type), theme palette resolved explicitly after
      the named-theme lookup left fillborders empty (all three tapes
      fixed, c78a7f4); install.gif rendered 700K and committed past the
      render-artifact ignore rules as the explicit showcase exception
      (tapes/out is otherwise house-ignored; re-render with just record)

### Verification

- In-box: bash -n / shellcheck / shfmt -i 4 green; static suite green
  with the new assertions; repo-mode + remote-mode install smokes green.
- Host render green (install.gif committed); open: Human `just check`,
  push (⇡ so the raw one-liner serves the logo + tarball), verdict.

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:27:36Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:28:11Z

  gate-attributed · tool: edit · paths: /home/aemonge/projects/devbox/tapes/install.tape · at 2026-11-03T15:30:02Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:30:14Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:30:20Z

  gate-attributed · tool: edit · paths: /home/aemonge/projects/devbox/tapes/install.tape · at 2026-11-03T15:35:06Z

  gate-attributed · tool: edit · paths: /home/aemonge/projects/devbox/tapes/intro.tape · at 2026-11-03T15:35:06Z

  gate-attributed · tool: edit · paths: /home/aemonge/projects/devbox/tapes/doctor.tape · at 2026-11-03T15:35:06Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:35:10Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:35:17Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:39:22Z

  gate-attributed · tool: bash · paths: — · at 2026-11-03T15:39:29Z
