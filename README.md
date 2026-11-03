# devbox

Mount-isolated developer box using [Bubblewrap](https://github.com/containers/bubblewrap).
One development environment for interactive shells, [Pi](https://github.com/badlogic/pi-mono), OpenCode, and tools.

`devbox` builds a hard-bounded sandbox around a single project: the target is
writable, system paths and the rest of your home stay read-only or absent,
critical infrastructure (`.github`, lockfiles, `.turbo`, `.cargo`) is protected
even inside a writable target, and every agent runtime inside the box shares
one developer state closure — Pi state, OpenCode state, host toolchains, AWS,
clipboard, terminal sockets — under one explicit policy.

## Requirements

- Linux with user namespaces (checked at startup; Bubblewrap cannot run without them)
- `bash`
- [`bwrap`](https://github.com/containers/bubblewrap) (Bubblewrap) in `PATH`
- `git` (wrapped by the in-box policy wrapper at runtime)

## Install

From a host terminal (not inside an existing devbox):

```sh
git clone <this-repo> ~/usr/devbox   # or your preferred location
cd ~/usr/devbox
./install.sh                  # copy mode: bin/* -> ~/.local/bin
./install.sh --symlink        # or symlink mode: points at the repository
```

Both modes check dependencies, install into `~/.local` (override with
`--prefix DIR`), and verify with `devbox --version`. `~/.local/bin` must be
on your `PATH`.

Prefer doing it by hand? The symlink workflow is what `--symlink` does:

```sh
ln -sfn ~/usr/devbox/bin/devbox ~/.local/bin/devbox
devbox --version
```

## Usage

```
devbox [COMMAND [ARG...]] [-- [TARGET] [DEVBOX_OPTIONS...]]
```

Arguments before the first `--` run inside the box; with no command you get an
interactive Zsh login shell. Arguments after `--` select the target (default:
`$PWD`) and configure the box.

```sh
devbox                              # zsh in $PWD
devbox -- ~/src/project             # zsh in the selected target
devbox pi "fix this" -- ~/src/app   # Pi in the shared developer box
devbox opencode -- ~/src/app -w     # OpenCode with browser developer mode
devbox aws sts get-caller-identity  # AWS CLI with default AWS integration
devbox -- --doctor                  # comprehensive diagnostics, no launch
devbox -- --validate                # validation suite, no launch
```

Key options (see `devbox -- --help` for the full list):

| Option | Meaning |
| --- | --- |
| `--ro` / `--rw` | Mount target read-only / read-write (default) |
| `--add PATH` / `--add-rw PATH` | Extra path read-only / read-write |
| `--no-network` | Unshare the network namespace |
| `--no-aws`, `--no-clipboard`, `--no-host-tools` | Hide AWS, clipboard, host toolchains |
| `--locked` | Read-only, offline, credential-free hardened preset |
| `-s, --ssh-agent` | Forward `SSH_AUTH_SOCK` (opt-in) |
| `-w, --web-developer` | GUI mode + Chromium DevTools |
| `--allow-infra`, `--allow-pi-config` | Relax a specific protection explicitly |

## Filesystem boundary

The target is writable by default. `.git` stays writable while `.github`,
`.turbo`, `.cargo`, and common lockfiles are read-only unless `--allow-infra`
is used. System paths and host paths outside explicit mounts remain read-only
or absent. Pi credentials and development state, OpenCode development state,
host-tool caches, AWS, clipboard, SSH, terminal, and optional GUI integrations
share one developer box; other Pi configuration stays read-only unless
`--allow-pi-config` is explicit.

## Security scope

Defaults favor development convenience: network, AWS credentials, and
clipboard are available when detected, and anything in the box can use them.
SSH agent forwarding is opt-in. Harden a run with `--no-network`, `--no-aws`,
`--no-clipboard`, `--no-host-tools`, `--ro`, or the `--locked` preset
(read-only, offline, credential-free).

Inside the box, `git` is transparently backed by the `devbox-git` policy
wrapper: normal local work passes, while network Git operations, history
rewriting, destructive cleanup, and configuration escapes are denied with an
explanation. The wrapper's denials are authoritative — do not bypass them.

## What's in the box

| Script | Role |
| --- | --- |
| `bin/devbox` | Sandbox launcher: target resolution, bind policy, integrations, `bwrap` assembly |
| `bin/devbox-git` | Policy-enforcing git wrapper used inside the box |
| `bin/devbox-pi-guard` | Pi entry guard: agent-context injection, safe passthrough |
| `bin/devbox-opencode-guard` | OpenCode entry guard |
| `bin/devbox-opencode-integrity` | Structural OpenCode plugin preflight |
| `bin/devbox-pi-title.ts` | Pi title extension |
| `bin/devbox-agent-context.md` | Read-only agent guidance mounted into every box |

## Performance

Startup measures ~475ms wall on the reference host (baseline 622ms): ~20ms
bash parse, ~50ms cache-and-discovery, ~122ms mount assembly, ~186ms policy
validation and integration closure, ~80ms environment construction, ~27ms
bwrap exec. The remaining cost is the price of the adversarial policy
validation — the same logic the ~700-assertion suite enforces. Measure with
`just bench` (hyperfine, phase trace, fork census, hot-line report).

## Development

The repository gates itself with [`just`](https://github.com/casey/just):

```sh
just lint        # shellcheck across bin/ + install.sh
just fmt         # shfmt in-place
just fmt-check   # shfmt diff-check (CI gate)
just test        # bats: syntax + smoke + guard contracts
just check       # lint + fmt-check + test — the one command before a commit
just install     # ./install.sh --prefix ~/.local (PREFIX=DIR to override)
just verify      # --version through the installed path
just record      # render VHS demos to tapes/out/ (host-side: needs ttyd, ffmpeg, Chrome)
```

Scope is Linux-only by design: Bubblewrap is the backend, and there is no
macOS path. Platform work is specified under `openspec/` — the spec-driven
change flow (brainstorm → investigate → plan → execute) that governs how this
repo changes.

## License

[MIT](LICENSE)
