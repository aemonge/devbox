#!/usr/bin/env bash
# devbox installer — host-side. Installs the bin/ scripts into a prefix and
# verifies the result. Runs from a normal host shell, never inside a devbox.

set -Eeuo pipefail

readonly PROGRAM_NAME="devbox-installer"

error() {
    printf '%s: %s\n' "${PROGRAM_NAME}" "$*" >&2
}

usage() {
    cat <<'USAGE_EOF'
Usage: install.sh [--prefix DIR] [--symlink]

Installs devbox into PREFIX (default: ~/.local):
  copy mode (default)  copies bin/* to PREFIX/bin/
  symlink mode         creates PREFIX/bin/devbox -> <repo>/bin/devbox;
                       sibling scripts resolve through the real repository

Both modes verify the install by running `devbox --version` through the
installed path. Missing dependencies are reported and abort the install.

Options:
  --prefix DIR   Installation prefix (default: ~/.local)
  --symlink      Symlink the repository instead of copying
  -h, --help     Show this help and exit
USAGE_EOF
}

PREFIX="${HOME}/.local"
INSTALL_MODE="copy"

while [[ $# -gt 0 ]]; do
    case "$1" in
    --prefix)
        if [[ $# -lt 2 ]]; then
            error "missing argument for --prefix"
            exit 1
        fi
        PREFIX="$2"
        shift 2
        ;;
    --symlink)
        INSTALL_MODE="symlink"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *)
        error "unknown argument: $1"
        usage >&2
        exit 1
        ;;
    esac
done

REPO_ROOT="$(cd -- "$(dirname -- "$(realpath "${BASH_SOURCE[0]}")")" && pwd -P)"
readonly REPO_ROOT

if [[ ! -d "${REPO_ROOT}/bin" ]]; then
    error "repository layout unexpected: ${REPO_ROOT}/bin is missing"
    exit 1
fi

# --- dependencies ------------------------------------------------------------

if ! command -v bash >/dev/null 2>&1; then
    error "bash not found in PATH"
    exit 1
fi
if ! command -v git >/dev/null 2>&1; then
    error "git not found in PATH"
    exit 1
fi
if [[ "$(uname -s)" == "Linux" ]] && ! command -v bwrap >/dev/null 2>&1; then
    error "bubblewrap (bwrap) not found in PATH"
    error "install bubblewrap before running devbox"
    exit 1
fi

# --- install -----------------------------------------------------------------

BIN_DIR="${PREFIX}/bin"
mkdir -p -- "${BIN_DIR}"

if [[ "${INSTALL_MODE}" == "symlink" ]]; then
    ln -sfn -- "${REPO_ROOT}/bin/devbox" "${BIN_DIR}/devbox"
    printf 'devbox-installer: symlinked %s -> %s\n' "${BIN_DIR}/devbox" "${REPO_ROOT}/bin/devbox"
else
    if [[ -L "${BIN_DIR}/devbox" ]]; then
        rm -f -- "${BIN_DIR}/devbox"
    fi
    cp -p -- "${REPO_ROOT}/bin/"* "${BIN_DIR}/"
    printf 'devbox-installer: installed %s scripts to %s\n' "$(find "${REPO_ROOT}/bin" -maxdepth 1 -type f | wc -l)" "${BIN_DIR}"
fi

# --- verify ------------------------------------------------------------------

if "${BIN_DIR}/devbox" --version; then
    printf 'devbox-installer: verify OK — devbox is available at %s\n' "${BIN_DIR}/devbox"
    printf 'devbox-installer: make sure %s is on your PATH\n' "${BIN_DIR}"
else
    error "verification failed: ${BIN_DIR}/devbox --version did not succeed"
    exit 1
fi
