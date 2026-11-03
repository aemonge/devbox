#!/usr/bin/env bash
# devbox installer — host-side. Installs the bin/ scripts into a prefix and
# verifies the result. Runs from a normal host shell, never inside a devbox.
# Piped invocations (curl ... | bash) and --remote install straight from the
# main tarball — no repository clone required.

set -Eeuo pipefail

readonly PROGRAM_NAME="devbox-installer"
readonly REMOTE_TARBALL_URL="https://github.com/aemonge/devbox/archive/refs/heads/main.tar.gz"

error() {
    printf '%s: %s\n' "${PROGRAM_NAME}" "$*" >&2
}

usage() {
    cat <<'USAGE_EOF'
Usage: install.sh [--prefix DIR] [--symlink] [--remote]

Installs devbox into PREFIX (default: ~/.local):
  copy mode (default)  copies bin/* to PREFIX/bin/
  symlink mode         creates PREFIX/bin/devbox -> <repo>/bin/devbox;
                       sibling scripts resolve through the real repository
  remote mode          fetches the main tarball instead of using a local
                       repository — automatic when piped (curl ... | bash),
                       or forced with --remote; implies copy mode

All modes verify the install by running `devbox --version` through the
installed path and save logo.png to PREFIX/share/devbox/. Missing
dependencies are reported and abort the install.

Options:
  --prefix DIR   Installation prefix (default: ~/.local)
  --symlink      Symlink the repository instead of copying
  --remote       Install from the main tarball, no clone required
  -h, --help     Show this help and exit
USAGE_EOF
}

PREFIX="${HOME}/.local"
INSTALL_MODE="copy"
REMOTE_REQUESTED=0

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
    --remote)
        REMOTE_REQUESTED=1
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

INSTALLER_SOURCE="${BASH_SOURCE[0]:-}"
STAGING_DIR=""

REMOTE_MODE="${REMOTE_REQUESTED}"
if [[ -z "${INSTALLER_SOURCE}" || "${INSTALLER_SOURCE}" == "bash" || "${INSTALLER_SOURCE}" == "sh" ]]; then
    # Piped invocation (curl ... | bash): the installer is not a file on
    # disk, so remote mode is the only path.
    REMOTE_MODE=1
fi

if [[ "${INSTALL_MODE}" == "symlink" && "${REMOTE_MODE}" -eq 1 ]]; then
    error "--symlink needs a repository checkout; run ./install.sh --symlink from a clone"
    exit 1
fi

if [[ "${REMOTE_MODE}" -eq 1 ]]; then
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        error "remote install needs curl or wget in PATH"
        exit 1
    fi
    STAGING_DIR="$(mktemp -d "${TMPDIR:-/tmp}/devbox-install.XXXXXX")"
    trap 'rm -rf -- "${STAGING_DIR}"' EXIT
    printf '%s: fetching %s\n' "${PROGRAM_NAME}" "${REMOTE_TARBALL_URL}"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "${REMOTE_TARBALL_URL}" | tar -xz -C "${STAGING_DIR}"
    else
        wget -qO- "${REMOTE_TARBALL_URL}" | tar -xz -C "${STAGING_DIR}"
    fi
    REPO_ROOT="$(printf '%s\n' "${STAGING_DIR}"/*/ | head -n 1)"
else
    REPO_ROOT="$(cd -- "$(dirname -- "$(realpath "${INSTALLER_SOURCE}")")" && pwd -P)"
fi
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
    find "${REPO_ROOT}/bin" -maxdepth 1 -type f -exec cp -p -t "${BIN_DIR}/" {} +
    printf 'devbox-installer: installed %s scripts to %s\n' "$(find "${REPO_ROOT}/bin" -maxdepth 1 -type f | wc -l)" "${BIN_DIR}"
fi

# --- logo ---------------------------------------------------------------------

SHARE_DIR="${PREFIX}/share/devbox"
mkdir -p -- "${SHARE_DIR}"
if [[ -f "${REPO_ROOT}/logo.png" ]]; then
    cp -p -- "${REPO_ROOT}/logo.png" "${SHARE_DIR}/logo.png"
    if command -v chafa >/dev/null 2>&1; then
        chafa --size 44x22 "${SHARE_DIR}/logo.png" ||
            printf '%s: logo saved to %s\n' "${PROGRAM_NAME}" "${SHARE_DIR}/logo.png"
    elif [[ -n "${KITTY_WINDOW_ID:-}" ]] && command -v kitten >/dev/null 2>&1; then
        kitten icat --clear "${SHARE_DIR}/logo.png" 2>/dev/null ||
            printf '%s: logo saved to %s\n' "${PROGRAM_NAME}" "${SHARE_DIR}/logo.png"
    else
        printf '%s: logo saved to %s\n' "${PROGRAM_NAME}" "${SHARE_DIR}/logo.png"
    fi
fi

# --- verify ------------------------------------------------------------------

if "${BIN_DIR}/devbox" --version; then
    printf 'devbox-installer: verify OK — devbox is available at %s\n' "${BIN_DIR}/devbox"
    printf 'devbox-installer: make sure %s is on your PATH\n' "${BIN_DIR}"
else
    error "verification failed: ${BIN_DIR}/devbox --version did not succeed"
    exit 1
fi
