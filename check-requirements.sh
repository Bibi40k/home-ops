#!/usr/bin/env bash

main() {
    verify_binaries
}

_has_binary() {
    command -v "${1}" >/dev/null 2>&1 || {
        _log "ERROR" "${1} is not installed or not found in \$PATH"
        _log "HINT" "brew install ${1}"
        exit 1
    }
}

verify_binaries() {
    # Required binaries
    # https://github.com/k8s-at-home/template-cluster-k3s#required
    _has_binary "age"
    _has_binary "ansible"
    _has_binary "direnv"
    _has_binary "flux"
    _has_binary "ipcalc"
    _has_binary "jq"
    _has_binary "kubectl"
    _has_binary "shellcheck"
    _has_binary "sops"
    _has_binary "task"
    _has_binary "terraform"

    # Optional binaries
    # https://github.com/k8s-at-home/template-cluster-k3s#optional
    _has_binary "gitleaks"
    _has_binary "helm"
    _has_binary "kustomize"
    _has_binary "pre-commit"
    _has_binary "prettier"

    success
}

success() {
    echo "All binaries exists!"
    exit 0
}

_log() {
    local type="${1}"
    local msg="${2}"
    printf "[%s] [%s] %s\n" "$(date -u)" "${type}" "${msg}"
}

main "$@"
