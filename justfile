# devbox repository gates — `just <recipe>`; `just check` before any commit.
set shell := ["bash", "-euo", "pipefail", "-c"]

# Every shell script (bin/ plus installer and adopted legacy test suite);
# .md and .ts files are not shell.
shell_scripts := "bin/devbox bin/devbox-git bin/devbox-opencode-guard bin/devbox-opencode-integrity bin/devbox-pi-guard install.sh bin/test/devbox-agent-context-test bin/test/devbox-cache-test bin/test/devbox-git-identity-test bin/test/devbox-git-policy-test bin/test/devbox-live-extended-test bin/test/devbox-live-test bin/test/devbox-opencode-integrity-test bin/test/devbox-opencode-preflight-test bin/test/devbox-parser-test bin/test/devbox-pi-parity-test bin/test/devbox-pi-state-test bin/test/devbox-pty-test bin/test/devbox-skills-symlink-test bin/test/devbox-static-test bin/test/devbox-test-adapter"

# default: run the full gate
default: check

# shellcheck across bin/ shell scripts (zero findings allowed)
lint:
    shellcheck {{shell_scripts}}

# shfmt in-place, house style: 4-space indent, patterns at case level
fmt:
    shfmt -i 4 -w {{shell_scripts}}

# verify formatting without writing (CI gate)
fmt-check:
    shfmt -i 4 --diff {{shell_scripts}}

# bats suites: syntax + smoke + guard contracts
# (`unit` is reserved for the function-level harness that lands with the
# lib/ module split — the monolith cannot be sourced without side effects)
test:
    bats tests/

# install into a prefix (default ~/.local; override with PREFIX=DIR)
install:
    ./install.sh --prefix "${PREFIX:-$HOME/.local}"

# verify an existing install (override with PREFIX=DIR)
verify:
    "${PREFIX:-$HOME/.local}/bin/devbox" --version

# render the VHS demos into tapes/out/ (needs vhs: ttyd + ffmpeg + chrome;
# typically a host-side step)
record:
    mkdir -p tapes/out
    vhs tapes/intro.tape
    vhs tapes/doctor.tape

# aggregate gate
check: lint fmt-check test
