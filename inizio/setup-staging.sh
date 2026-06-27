#!/usr/bin/env bash
#
# setup-staging.sh — configure nginx to serve Hepeer on the STAGING host.
#
# Run this on the box that answers for staging-www.hepeer.com.
# It's a thin wrapper around setup-nginx.sh with staging settings baked in.
#
# Usage:
#   sudo ./inizio/setup-staging.sh                 # HTTP + Let's Encrypt HTTPS
#   sudo ENABLE_HTTPS=0 ./inizio/setup-staging.sh  # HTTP only (opt out of HTTPS)
#
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export SERVER_NAME="staging-www.hepeer.com"
export SITE_NAME="hepeer-staging"
export LISTEN_PORT="${LISTEN_PORT:-80}"

# HTTPS is on by default; set ENABLE_HTTPS=0 to opt out.
# EMAIL is the contact address Let's Encrypt uses for expiry notices.
export ENABLE_HTTPS="${ENABLE_HTTPS:-1}"
export EMAIL="${EMAIL:-admin@hepeer.com}"

exec "${SCRIPT_DIR}/setup-nginx.sh" "$@"
