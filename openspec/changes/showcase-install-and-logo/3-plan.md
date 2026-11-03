# Plan

> Spec: showcase-install-and-logo · the contract for execution

## Estimate

~1 hour across three slices, high confidence. All mechanics are known:
one tarball fetch, one installer brain, house tape style. The only
host-side acts are Human's: the VHS render and the commit gate.

## Skills

- `bash-defensive-patterns` — guards before effects, strict mode
  preserved; governs the installer edit.

## Workflow

Tarball bootstrap (investigate finding): remote mode points the EXISTING
copy+verify brain at a fetched extraction; no second install
implementation, no per-file fetch list. Logo display is best-effort
(chafa → kitty icat → path print) and never fails the install. The tape
records the real one-liner against a throwaway HOME wiped at start
(banked lesson), and renders host-side only.

## Slices

### Slice 1 — installer remote mode + logo + contract tests

- [ ] install.sh: piped-invocation detection (`BASH_SOURCE` unusable) and
      explicit `--remote`; fetch `main.tar.gz` with curl (fallback wget)
      into a staging mktemp dir; `REPO_ROOT` = extraction; trap-cleanup;
      `--symlink` + remote refused with a clear diagnostic; fetch-tool
      check in remote mode only
- [ ] install.sh: logo persisted to `${PREFIX}/share/devbox/logo.png`,
      displayed best-effort (chafa → kitten icat → path print)
- [ ] static test: installer contract assertions (tarball URL, piped
      detection, fetch fallback, symlink refusal, logo persistence +
      fallback), helper mirrors the existing grep -F pattern
- Commit `feat: install devbox without cloning the repository`

### Slice 2 — README face

- [ ] Logo header at top; Install section gains the curl one-liner
      (remote first, clone second); Showcase section embeds
      `tapes/out/install.gif`
- Commit `docs: lead with the logo and the no-clone install`

### Slice 3 — showcase tape

- [ ] tapes/install.tape (house style): throwaway demo HOME wiped at
      start, real curl one-liner, logo landing, `devbox --version` + a
      first launch
- [ ] Human renders on the host: `vhs tapes/install.tape`
- Commit `docs: add the install showcase tape`

## Verification

- Per slice: `bash -n`, shellcheck, `shfmt -i 4` clean; static suite
  green; repo-mode install still verifies in-box against a /tmp prefix.
- Remote-mode smoke: fetch + install into a throwaway prefix (in-box if
  the gate allows network in a script, otherwise Human host-side).
- Whole change: Human renders the tape, commits the GIF; `just check`
  green on host.

## History

- `feat: install devbox without cloning the repository`
- `docs: lead with the logo and the no-clone install`
- `docs: add the install showcase tape`
