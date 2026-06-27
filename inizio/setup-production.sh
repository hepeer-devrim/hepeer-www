#!/usr/bin/env bash
#
# setup-production.sh — configure nginx to serve Hepeer on the PRODUCTION host.
#
# Run this on the box that answers for www.hepeer.com.
# It's a thin wrapper around setup-nginx.sh with production settings baked in.
#
# Usage:
#   sudo ./inizio/setup-production.sh
#
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

export SERVER_NAME="www.hepeer.com"
export SITE_NAME="hepeer-production"
export LISTEN_PORT="${LISTEN_PORT:-80}"

exec "${SCRIPT_DIR}/setup-nginx.sh" "$@"
