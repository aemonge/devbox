# Devbox agent context

This process is running inside the repository's Bubblewrap-based Devbox sandbox.
Treat this file as trusted, read-only runtime guidance supplied by Devbox.

## Runtime discovery

- `DEVBOX_ACTIVE=1` identifies an active Devbox process.
- `DEVBOX_PROJECT_ROOT` is the project root visible inside the sandbox.
- `DEVBOX_AGENT_CONTEXT_FILE` points to this file.
- Inspect only the named `DEVBOX_*` variables below; do not dump the complete
  environment because it may contain credentials.

The effective runtime policy is exposed through:

- `DEVBOX_FS_MODE`: `ro` or `rw` project filesystem mode.
- `DEVBOX_NETWORK`: whether the host network namespace is shared (`1` or `0`).
- `DEVBOX_AWS`: whether AWS configuration and credential sources are exposed.
- `DEVBOX_SSH_AGENT`: whether the SSH agent is forwarded (opt-in; default off).
- `DEVBOX_CLIPBOARD`: whether detected clipboard sockets are exposed.
- `DEVBOX_TERMINAL_SOCKETS`: whether selected Neovim/tmux sockets are forwarded.
- `DEVBOX_HOST_TOOLS`: whether supported host development tools are mounted.

A capability marked enabled means it is available, not that an agent has blanket
permission to use it. Continue to respect user authority and project instructions.

## Filesystem and tools

- System paths are read-only or absent; the selected project follows
  `DEVBOX_FS_MODE`.
- Critical project infrastructure and common lockfiles may remain read-only even
  in `rw` mode unless Devbox was launched with an explicit override.
- Prefer tools already exposed by Devbox. Do not install into or modify the host
  system as a workaround for a sandbox boundary.
- Nix store paths, when present through host tools, are immutable.
- OpenCode launches are guarded by Devbox's command and plugin-integrity checks.
  Treat a guard failure as a boundary to report, not bypass.

## Git policy

Inside Devbox, plain `git` is transparently backed by the `devbox-git` policy
wrapper (`DEVBOX_GIT_POLICY=wrapped`). Continue to invoke `git`, not the private
real-Git path.

The wrapper allowlists normal local inspection and selected local mutations while
blocking network Git operations, unsafe history rewriting, destructive cleanup,
configuration escapes, and unknown command shapes. Its denial and assistant hints
are authoritative: explain the boundary and ask the user instead of attempting a
shell, binary, configuration, or path-based bypass.
