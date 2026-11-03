# Brainstorm

> Spec: showcase-install-and-logo · why this exists

## Pain

Installing devbox today requires cloning the git repository: `install.sh`
resolves `REPO_ROOT` from its own path, so a curious visitor must
`git clone` a 3,900-line bash project to try a sandbox tool that is
supposed to take only what it needs. The repo also has no face — `logo.png`
sits unused at the root, the README opens with plain text, and there is no
motion showcase of the install experience. The last milestone: make the
install one curl away, put the logo to work, and let a VHS tape show it.

## Questions

- Q1 — What is the minimal no-clone install path that reuses the existing
  copy+verify installer without a per-file fetch list that can drift from
  `bin/`?
- Q2 — How does the logo display after install across terminal graphics
  support levels (chafa, kitty icat, plain fallback) without becoming a
  hard dependency?
- Q3 — What must the showcase tape contain to demonstrate the real
  install-to-launch experience in the house tape style, and where does the
  render land (host-only lesson: VHS Chromium cannot nest in the box)?

<!-- Direction (optional, free): tarball-over-file-list — one canonical
fetch path, no drift, logo rides along. The installer keeps exactly one
copy+verify brain; remote mode only changes where the bytes come from. -->
