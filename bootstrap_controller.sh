#!/usr/bin/env bash
# ==============================================================================
# Minimal Controller Bootstrap — Rocky Linux 9
# ==============================================================================

set -euo pipefail

log() { printf '[bootstrap] %s\n' "$*" >&2; }

if [[ "$(id -u)" -ne 0 ]]; then
    log "Run with sudo or as root."
    exit 1
fi

if ! grep -qi "rocky" /etc/os-release; then
    log "Warning: this script is intended for Rocky Linux systems."
fi

log "Refreshing package metadata..."
dnf -y makecache --refresh

log "Installing Python 3.11 and baseline tooling..."
dnf -y install \
    git \
    python3.11 \
    python3.11-devel \
    openssh-server \
    firewalld \
    make \
    curl \
    wget \
    tar \
    gzip \
    unzip \
    vim \
    tmux \
    jq \
    rsync

log "Enabling and starting essential services..."
systemctl enable --now sshd firewalld

log "Allowing SSH in firewalld..."
firewall-cmd --permanent --add-service=ssh
firewall-cmd --reload

log "Bootstrap complete."
exit 0
