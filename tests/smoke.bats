#!/usr/bin/env bats

# Smoke tests for parse-only devbox entry points.
#
# Honesty boundary: --version and --help exit inside the argument parser, so
# they run anywhere. --validate and --doctor dispatch before the bwrap
# assembly but their validation suites re-invoke the script, and those
# sub-invocations need user namespaces. Inside a nested sandbox that refusal
# is the correct, observable behavior — so each test probes namespace
# capability first (mirroring check_bwrap_namespace_support) and asserts the
# environment-appropriate contract instead of faking one.

setup() {
    cd "${BATS_TEST_DIRNAME}/.."
}

DEVBOX_SCRIPT="bin/devbox"

# Same probe shape as check_bwrap_namespace_support in bin/devbox.
namespaces_available() {
    local -a probe
    probe=(bwrap --unshare-user-try --ro-bind /usr /usr --ro-bind /bin /bin --ro-bind /lib /lib)
    [[ -d /lib64 ]] && probe+=(--ro-bind /lib64 /lib64)
    probe+=(--proc /proc --dev /dev -- /bin/sh -c 'exit 0')
    "${probe[@]}" >/dev/null 2>&1
}

@test "--version reports program and backend" {
    run "${DEVBOX_SCRIPT}" --version
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "devbox 0.2.0" ]
    [ "${lines[1]}" = "Sandbox: Bubblewrap" ]
}

@test "-V is --version" {
    run "${DEVBOX_SCRIPT}" -V
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "devbox 0.2.0" ]
}

@test "--help shows usage header and examples" {
    run "${DEVBOX_SCRIPT}" --help
    [ "$status" -eq 0 ]
    [[ "${output}" == *"Mount-isolated developer box using Bubblewrap."* ]]
    [[ "${output}" == *"Usage:"* ]]
    [[ "${output}" == *"--locked"* ]]
    [[ "${output}" == *"Security scope:"* ]]
}

@test "-h is --help" {
    run "${DEVBOX_SCRIPT}" -h
    [ "$status" -eq 0 ]
    [[ "${output}" == *"Usage:"* ]]
}

@test "--help and --version agree on the version" {
    run "${DEVBOX_SCRIPT}" --help
    local help_first
    help_first="${lines[0]}"
    run "${DEVBOX_SCRIPT}" --version
    [ "${help_first}" = "${lines[0]}" ]
}

@test "--validate matches real namespace capability" {
    if namespaces_available; then
        run "${DEVBOX_SCRIPT}" --validate
        [ "$status" -eq 0 ]
    else
        run "${DEVBOX_SCRIPT}" --validate
        [ "$status" -eq 1 ]
        [[ "${output}" == *"cannot create the namespaces"* ]]
        [[ "${output}" == *"normal host shell"* ]]
    fi
}

@test "--doctor refuses honestly without namespaces" {
    if namespaces_available; then
        # On a capable host --doctor inspects the real user environment
        # (OpenCode plugins, Pi state); that contract belongs to host-side
        # validation, not CI. Skip rather than fake it.
        skip "namespace-capable host: doctor depends on the real user environment"
    fi
    run "${DEVBOX_SCRIPT}" --doctor
    [ "$status" -eq 1 ]
    [[ "${output}" == *"cannot create the namespaces"* ]]
}
