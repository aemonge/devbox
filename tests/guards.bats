#!/usr/bin/env bats

# Contract tests for the in-box entry guards. The real pi/opencode binaries
# are replaced by tests/fixtures/fake-runtime, which echoes its arguments, so
# passthrough (no injected flags) and injection (context/extension flags
# present) are both observable.

setup() {
    cd "${BATS_TEST_DIRNAME}/.."
    FAKE="${BATS_TEST_DIRNAME}/fixtures/fake-runtime"
    CONTEXT="${BATS_TEST_DIRNAME}/fixtures/context.md"
    chmod +x "${FAKE}"
}

# --- devbox-pi-guard -------------------------------------------------------

@test "pi-guard refuses without DEVBOX_REAL_PI" {
    run env -u DEVBOX_REAL_PI bin/devbox-pi-guard
    [ "$status" -eq 1 ]
    [[ "${output}" == *"DEVBOX_REAL_PI is required"* ]]
}

@test "pi-guard refuses without a readable agent context" {
    run env DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="/nonexistent/context.md" \
        bin/devbox-pi-guard -p hi
    [ "$status" -eq 1 ]
    [[ "${output}" == *"not readable"* ]]
}

@test "pi-guard passes subcommands through untouched" {
    for passthrough in install remove uninstall update list config --help --version; do
        run env DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
            bin/devbox-pi-guard "${passthrough}"
        [ "$status" -eq 0 ]
        [ "${lines[0]}" = "${passthrough}" ]
    done
}

@test "pi-guard --no-context-files passes through untouched" {
    run env DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
        bin/devbox-pi-guard -p hi --no-context-files
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "-p" ]
    [ "${lines[1]}" = "hi" ]
    [ "${lines[2]}" = "--no-context-files" ]
}

@test "pi-guard injects the agent context by default" {
    run env -u DEVBOX_PI_TITLE_EXTENSION DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
        bin/devbox-pi-guard -p hi
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "--append-system-prompt" ]
    [ "${lines[1]}" = "${CONTEXT}" ]
    [ "${lines[2]}" = "-p" ]
    [ "${lines[3]}" = "hi" ]
}

@test "pi-guard -- stops injection scanning" {
    run env -u DEVBOX_PI_TITLE_EXTENSION DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
        bin/devbox-pi-guard run -- --no-context-files
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "--append-system-prompt" ]
    [ "${lines[1]}" = "${CONTEXT}" ]
    [ "${lines[2]}" = "run" ]
    [ "${lines[3]}" = "--" ]
    [ "${lines[4]}" = "--no-context-files" ]
}

@test "pi-guard refuses an unreadable title extension" {
    run env DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
        DEVBOX_PI_TITLE_EXTENSION="/nonexistent/extension.ts" bin/devbox-pi-guard -p hi
    [ "$status" -eq 1 ]
    [[ "${output}" == *"title extension is not readable"* ]]
}

@test "pi-guard injects title extension when configured" {
    run env DEVBOX_REAL_PI="${FAKE}" DEVBOX_AGENT_CONTEXT_FILE="${CONTEXT}" \
        DEVBOX_PI_TITLE_EXTENSION="${CONTEXT}" bin/devbox-pi-guard -p hi
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "--append-system-prompt" ]
    [ "${lines[1]}" = "${CONTEXT}" ]
    [ "${lines[2]}" = "--extension" ]
    [ "${lines[3]}" = "${CONTEXT}" ]
    [ "${lines[4]}" = "-p" ]
}

# --- devbox-opencode-guard -------------------------------------------------

@test "opencode-guard refuses without DEVBOX_REAL_OPENCODE" {
    run env -u DEVBOX_REAL_OPENCODE -u DEVBOX_OPENCODE_INTEGRITY_HELPER \
        bin/devbox-opencode-guard
    [ "$status" -eq 1 ]
    [[ "${output}" == *"DEVBOX_REAL_OPENCODE is required"* ]]
}

@test "opencode-guard refuses without DEVBOX_OPENCODE_INTEGRITY_HELPER" {
    run env -u DEVBOX_OPENCODE_INTEGRITY_HELPER DEVBOX_REAL_OPENCODE="${FAKE}" \
        bin/devbox-opencode-guard
    [ "$status" -eq 1 ]
    [[ "${output}" == *"DEVBOX_OPENCODE_INTEGRITY_HELPER is required"* ]]
}

@test "opencode-guard passes plugin subcommand through before preflight" {
    run env DEVBOX_REAL_OPENCODE="${FAKE}" DEVBOX_OPENCODE_INTEGRITY_HELPER="/bin/false" \
        bin/devbox-opencode-guard plugin list
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "plugin" ]
    [ "${lines[1]}" = "list" ]
}

@test "opencode-guard runs preflight before launch" {
    run env DEVBOX_REAL_OPENCODE="${FAKE}" DEVBOX_OPENCODE_INTEGRITY_HELPER="/bin/true" \
        bin/devbox-opencode-guard run
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "run" ]
}

@test "opencode-guard fails closed when preflight fails" {
    run env DEVBOX_REAL_OPENCODE="${FAKE}" DEVBOX_OPENCODE_INTEGRITY_HELPER="/bin/false" \
        bin/devbox-opencode-guard run
    [ "$status" -eq 1 ]
    [[ "${output}" == *"plugin preflight failed"* ]]
}
