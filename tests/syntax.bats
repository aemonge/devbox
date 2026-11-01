#!/usr/bin/env bats

# Every shell script in bin/ must parse. The .md and .ts siblings are not
# shell and are covered by review, not bash -n.

BATS_TEST_DIRNAME_ROOT="${BATS_TEST_DIRNAME}/.."

@test "bash -n: bin/devbox" {
    bash -n "${BATS_TEST_DIRNAME_ROOT}/bin/devbox"
}

@test "bash -n: bin/devbox-git" {
    bash -n "${BATS_TEST_DIRNAME_ROOT}/bin/devbox-git"
}

@test "bash -n: bin/devbox-opencode-guard" {
    bash -n "${BATS_TEST_DIRNAME_ROOT}/bin/devbox-opencode-guard"
}

@test "bash -n: bin/devbox-opencode-integrity" {
    bash -n "${BATS_TEST_DIRNAME_ROOT}/bin/devbox-opencode-integrity"
}

@test "bash -n: bin/devbox-pi-guard" {
    bash -n "${BATS_TEST_DIRNAME_ROOT}/bin/devbox-pi-guard"
}
