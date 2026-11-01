# devbox repository gates — `just <recipe>`; `just check` before any commit.
set shell := ["bash", "-euo", "pipefail", "-c"]

# Every shell script in bin/ (the .md and .ts files are not shell).
shell_scripts := "bin/devbox bin/devbox-git bin/devbox-opencode-guard bin/devbox-opencode-integrity bin/devbox-pi-guard"

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

# aggregate gate
check: lint fmt-check
