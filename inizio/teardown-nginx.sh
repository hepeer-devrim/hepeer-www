#!/usr/bin/env bash
#
# teardown-nginx.sh — remove the Hepeer nginx site created by setup-nginx.sh.
#
# It removes the generated config (and its sites-enabled symlink), then
# reloads nginx. It does NOT uninstall the nginx package or touch your files.
#
# Usage:
#   sudo ./inizio/teardown-nginx.sh
#
#   SITE_NAME   nginx site/config name to remove. (default: hepeer)
#
set -euo pipefail

SITE_NAME="${SITE_NAME:-hepeer}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

if [[ "${EUID}" -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    exec sudo -E SITE_NAME="$SITE_NAME" bash "${BASH_SOURCE[0]}" "$@"
  fi
  die "Please run as root."
fi

removed=0
for f in \
  "/etc/nginx/sites-enabled/${SITE_NAME}.conf" \
  "/etc/nginx/sites-available/${SITE_NAME}.conf" \
  "/etc/nginx/conf.d/${SITE_NAME}.conf"; do
  if [[ -e "$f" || -L "$f" ]]; then
    rm -f "$f"
    log "Removed $f"
    removed=1
  fi
done

[[ "$removed" -eq 1 ]] || log "Nothing to remove for site '${SITE_NAME}'."

log "Testing & reloading nginx…"
nginx -t
if command -v systemctl >/dev/null 2>&1; then
  systemctl reload nginx 2>/dev/null || systemctl restart nginx
else
  nginx -s reload
fi
log "Done."
