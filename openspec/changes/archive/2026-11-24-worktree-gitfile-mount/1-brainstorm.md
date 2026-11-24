# Brainstorm

> Spec: worktree-gitfile-mount · why this exists

## Pain

A devbox aimed at a linked git worktree cannot run git at all. The
worktree's `.git` is a gitfile — `gitdir: <main-repo>/.git/worktrees/<name>`
— and that gitdir lives outside the mounted target, so every git command
inside the box dies at repo discovery, before the `devbox-git` policy
wrapper ever gets a vote. The failure also lies about itself: it reads
like git being broken or policy denying work, when the truth is an
unmounted path. Today's only remedy is human folklore — a hand-run
`--add` of the main repo's `.git` — and nothing names the real cause.

## Questions

- Q1 — What does git need from outside the mount for read work (status,
  diff, log, add)? The worktree gitdir carries HEAD, index and refs, but
  points at its common dir — the main `.git` — for objects, config and
  packed refs. Is binding the worktree gitdir alone ever enough, or does
  the common dir always ride along?
- Q2 — What must be writable for a commit to work in a worktree box? A
  commit writes new objects into the main `.git/objects` and index/HEAD
  into the worktree gitdir — both outside the mount. Binding the main
  `.git` read-write hands an in-box agent the host's whole repository
  (refs, objects, every branch): default, explicit opt-in, or never?
- Q3 — Detect-and-mount, or fail fast? Devbox can detect a `.git` gitfile
  whose gitdir resolves outside the mount and bind the referenced chain
  automatically under the existing policy — or refuse startup with a
  diagnostic that names the outside gitdir and the exact remedy — versus
  today's per-command death that masquerades as a policy denial.

<!-- Direction (optional, free): detect at startup, mount the referenced
gitdir chain, and let the existing policy decide writability — read-only
by default, a clean diagnostic when a commit needs more, explicit opt-in
for a writable main .git. Fail-fast honesty beats per-command flailing:
the box should name the boundary before git starves inside it. -->
