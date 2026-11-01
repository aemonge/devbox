#!/usr/bin/env bats

# Installer contract tests. Everything runs against a throwaway prefix, so
# the real ~/.local is never touched by the suite.

setup() {
    cd "${BATS_TEST_DIRNAME}/.."
    TMP_PREFIX="$(mktemp -d "${TMPDIR:-/tmp}/devbox-install-test.XXXXXX")"
}

teardown() {
    chmod -R u+w "${TMP_PREFIX}" 2>/dev/null || true
    rm -rf -- "${TMP_PREFIX}"
}

@test "install.sh --help shows usage" {
    run ./install.sh --help
    [ "$status" -eq 0 ]
    [[ "${output}" == *"Usage: install.sh"* ]]
    [[ "${output}" == *"--symlink"* ]]
}

@test "install.sh refuses unknown arguments" {
    run ./install.sh --bogus
    [ "$status" -eq 1 ]
    [[ "${output}" == *"unknown argument: --bogus"* ]]
}

@test "install.sh refuses --prefix without a value" {
    run ./install.sh --prefix
    [ "$status" -eq 1 ]
    [[ "${output}" == *"missing argument for --prefix"* ]]
}

@test "copy install places scripts and verifies" {
    run ./install.sh --prefix "${TMP_PREFIX}"
    [ "$status" -eq 0 ]
    [ -x "${TMP_PREFIX}/bin/devbox" ]
    [ -f "${TMP_PREFIX}/bin/devbox-git" ]
    [ -f "${TMP_PREFIX}/bin/devbox-pi-guard" ]
    [ -f "${TMP_PREFIX}/bin/devbox-agent-context.md" ]
    [ ! -L "${TMP_PREFIX}/bin/devbox" ]
    [[ "${output}" == *"devbox 0.2.0"* ]]
    [[ "${output}" == *"verify OK"* ]]
}

@test "copy install replaces a stale symlink" {
    mkdir -p "${TMP_PREFIX}/bin"
    ln -s /nonexistent/target "${TMP_PREFIX}/bin/devbox"
    run ./install.sh --prefix "${TMP_PREFIX}"
    [ "$status" -eq 0 ]
    [ -f "${TMP_PREFIX}/bin/devbox" ]
    [ ! -L "${TMP_PREFIX}/bin/devbox" ]
}

@test "symlink install points at the repository and verifies" {
    run ./install.sh --prefix "${TMP_PREFIX}" --symlink
    [ "$status" -eq 0 ]
    [ -L "${TMP_PREFIX}/bin/devbox" ]
    link_target="$(readlink "${TMP_PREFIX}/bin/devbox")"
    [[ "${link_target}" == *"$(pwd)/bin/devbox" ]]
    [[ "${output}" == *"devbox 0.2.0"* ]]
    [[ "${output}" == *"verify OK"* ]]
}

@test "installed devbox answers --version through the prefix" {
    ./install.sh --prefix "${TMP_PREFIX}" >/dev/null
    run "${TMP_PREFIX}/bin/devbox" --version
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "devbox 0.2.0" ]
}
