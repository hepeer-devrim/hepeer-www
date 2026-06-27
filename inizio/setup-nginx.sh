#!/usr/bin/env bash
#
# setup-nginx.sh — install & configure nginx to serve the Hepeer static website.
#
# It installs nginx if missing, generates an nginx server block from
# hepeer.conf.template (pointing at this repository's files), enables the
# site and reloads nginx.
#
# Usage:
#   sudo ./inizio/setup-nginx.sh [options]
#
# Options / environment variables:
#   SERVER_NAME   Domain to serve on.        (default: hepeer.local)
#                 Use "_" for a catch-all default server.
#   LISTEN_PORT   HTTP port to listen on.    (default: 80)
#   WEB_ROOT      Directory to serve.        (default: the repo root)
#   SITE_NAME     nginx site/config name.    (default: hepeer)
#
# Examples:
#   sudo ./inizio/setup-nginx.sh
#   sudo SERVER_NAME=hepeer.example.com ./inizio/setup-nginx.sh
#   sudo SERVER_NAME=_ LISTEN_PORT=8080 ./inizio/setup-nginx.sh
#
set -euo pipefail

# --- Resolve paths --------------------------------------------------------
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)"
TEMPLATE="${SCRIPT_DIR}/hepeer.conf.template"

# --- Configuration (overridable via env) ----------------------------------
SERVER_NAME="${SERVER_NAME:-hepeer.local}"
LISTEN_PORT="${LISTEN_PORT:-80}"
WEB_ROOT="${WEB_ROOT:-$REPO_ROOT}"
SITE_NAME="${SITE_NAME:-hepeer}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

# --- Pre-flight checks ----------------------------------------------------
[[ -f "$TEMPLATE" ]] || die "Template not found: $TEMPLATE"

# Re-exec via sudo if we're not root (nginx config lives in /etc).
if [[ "${EUID}" -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    log "Elevating privileges with sudo…"
    exec sudo -E SERVER_NAME="$SERVER_NAME" LISTEN_PORT="$LISTEN_PORT" \
               WEB_ROOT="$WEB_ROOT" SITE_NAME="$SITE_NAME" \
               bash "${BASH_SOURCE[0]}" "$@"
  fi
  die "Please run as root (this script writes to /etc/nginx)."
fi

[[ -d "$WEB_ROOT" ]] || die "Web root does not exist: $WEB_ROOT"

# --- Install nginx if needed ----------------------------------------------
if ! command -v nginx >/dev/null 2>&1; then
  log "nginx not found — installing…"
  if   command -v apt-get >/dev/null 2>&1; then
    apt-get update -qq && apt-get install -y nginx
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y nginx
  elif command -v yum >/dev/null 2>&1; then
    yum install -y nginx
  elif command -v zypper >/dev/null 2>&1; then
    zypper install -y nginx
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm nginx
  else
    die "Could not find a supported package manager to install nginx."
  fi
else
  log "nginx already installed: $(nginx -v 2>&1)"
fi

# --- Work out where nginx wants its config --------------------------------
# Debian/Ubuntu use sites-available + sites-enabled; others use conf.d.
if [[ -d /etc/nginx/sites-available && -d /etc/nginx/sites-enabled ]]; then
  AVAIL="/etc/nginx/sites-available/${SITE_NAME}.conf"
  ENABLED="/etc/nginx/sites-enabled/${SITE_NAME}.conf"
  USE_SYMLINK=1
else
  AVAIL="/etc/nginx/conf.d/${SITE_NAME}.conf"
  ENABLED="$AVAIL"
  USE_SYMLINK=0
fi

# --- Render the config from the template ----------------------------------
log "Generating nginx config for:"
printf '      server_name : %s\n' "$SERVER_NAME"
printf '      listen      : %s\n' "$LISTEN_PORT"
printf '      web root    : %s\n' "$WEB_ROOT"
printf '      config file : %s\n' "$AVAIL"

# Use a sed delimiter that won't appear in paths.
sed -e "s|__SERVER_NAME__|${SERVER_NAME}|g" \
    -e "s|__LISTEN_PORT__|${LISTEN_PORT}|g" \
    -e "s|__WEB_ROOT__|${WEB_ROOT}|g" \
    "$TEMPLATE" > "$AVAIL"

# --- Enable the site ------------------------------------------------------
if [[ "$USE_SYMLINK" -eq 1 ]]; then
  ln -sfn "$AVAIL" "$ENABLED"
  # Disable the stock default site if it's still serving on the same port.
  if [[ -e /etc/nginx/sites-enabled/default ]]; then
    warn "Disabling the stock 'default' site to avoid a clash."
    rm -f /etc/nginx/sites-enabled/default
  fi
fi

# --- Let nginx read the web root ------------------------------------------
# nginx workers run as www-data/nginx; make sure they can traverse the path.
NGINX_USER="$(awk '/^[[:space:]]*user[[:space:]]/{gsub(";","",$2); print $2; exit}' /etc/nginx/nginx.conf || true)"
if [[ -n "${NGINX_USER:-}" ]] && id "$NGINX_USER" >/dev/null 2>&1; then
  if command -v setfacl >/dev/null 2>&1; then
    # Grant traverse (x) on each ancestor dir and read on the web root.
    p="$WEB_ROOT"
    while [[ "$p" != "/" && -n "$p" ]]; do
      setfacl -m "u:${NGINX_USER}:--x" "$p" 2>/dev/null || true
      p="$(dirname "$p")"
    done
    setfacl -R -m "u:${NGINX_USER}:rX" "$WEB_ROOT" 2>/dev/null || true
  else
    warn "setfacl not available; if you hit 403 errors, ensure '$NGINX_USER' can read $WEB_ROOT."
  fi
fi

# --- Validate & reload ----------------------------------------------------
log "Testing nginx configuration…"
nginx -t

log "Reloading nginx…"
if command -v systemctl >/dev/null 2>&1; then
  systemctl enable nginx >/dev/null 2>&1 || true
  systemctl reload nginx 2>/dev/null || systemctl restart nginx
else
  nginx -s reload 2>/dev/null || nginx
fi

# --- Done -----------------------------------------------------------------
log "Done. Hepeer is being served."
if [[ "$SERVER_NAME" == "_" ]]; then
  printf '    Visit:  http://localhost%s/plans.html\n' \
    "$([[ "$LISTEN_PORT" == "80" ]] && echo "" || echo ":$LISTEN_PORT")"
else
  printf '    Visit:  http://%s%s/plans.html\n' \
    "$SERVER_NAME" "$([[ "$LISTEN_PORT" == "80" ]] && echo "" || echo ":$LISTEN_PORT")"
  printf '    (For a local domain, add to /etc/hosts:  127.0.0.1  %s)\n' "$SERVER_NAME"
fi
