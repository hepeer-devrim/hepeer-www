#!/usr/bin/env bash
#
# setup-staging.sh — configure nginx to serve Hepeer on the STAGING host.
#
# Run this on the box that answers for staging-www.hepeer.com.
# It's a thin wrapper around setup-nginx.sh with staging settings baked in.
#
# Usage:
#   sudo ./inizio/setup-staging.sh
#
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export SERVER_NAME="staging-www.hepeer.com"
export SITE_NAME="hepeer-staging"
export LISTEN_PORT="${LISTEN_PORT:-80}"

exec "${SCRIPT_DIR}/setup-nginx.sh" "$@"
