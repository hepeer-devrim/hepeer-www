#!/usr/bin/env bash
#
# setup-https.sh — obtain & install a Let's Encrypt TLS certificate for the
# Hepeer nginx site, turning on HTTPS with automatic renewal.
#
# This uses certbot's nginx plugin, which edits the server block that
# setup-nginx.sh already created (matched by server_name): it adds the
# listen 443 ssl block, wires in the certificate, and sets up an HTTP->HTTPS
# redirect. It is therefore meant to run AFTER setup-nginx.sh has put an
# HTTP site in place for the same SERVER_NAME.
#
# Usage:
#   sudo SERVER_NAME=www.hepeer.com EMAIL=you@example.com ./inizio/setup-https.sh
#
# Options / environment variables:
#   SERVER_NAME   Primary domain to certify.   (default: hepeer.local — but a
#                 public, DNS-resolvable domain is required for Let's Encrypt)
#   EXTRA_DOMAINS Space/comma-separated extra names to add to the same cert
#                 (Subject Alternative Names), e.g. "hepeer.com".  (default: none)
#   EMAIL         Contact email for expiry notices & account.  Strongly
#                 recommended; if empty we register without an email.
#   REDIRECT      "1" to force HTTP->HTTPS redirect, "0" to leave HTTP as-is.
#                                                              (default: 1)
#   LE_STAGING    "1" to use Let's Encrypt's STAGING environment (untrusted
#                 certs, generous rate limits) for testing.   (default: 0)
#
# Examples:
#   sudo SERVER_NAME=www.hepeer.com EMAIL=admin@hepeer.com ./inizio/setup-https.sh
#   sudo SERVER_NAME=www.hepeer.com EXTRA_DOMAINS=hepeer.com \
#        EMAIL=admin@hepeer.com ./inizio/setup-https.sh
#   # Dry-run against LE staging to avoid burning rate limits:
#   sudo SERVER_NAME=www.hepeer.com LE_STAGING=1 ./inizio/setup-https.sh
#
set -euo pipefail

# --- Configuration (overridable via env) ----------------------------------
SERVER_NAME="${SERVER_NAME:-hepeer.local}"
EXTRA_DOMAINS="${EXTRA_DOMAINS:-}"
EMAIL="${EMAIL:-}"
REDIRECT="${REDIRECT:-1}"
LE_STAGING="${LE_STAGING:-0}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[x]\033[0m %s\n' "$*" >&2; exit 1; }

# --- Re-exec via sudo if we're not root -----------------------------------
if [[ "${EUID}" -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    log "Elevating privileges with sudo…"
    exec sudo -E SERVER_NAME="$SERVER_NAME" EXTRA_DOMAINS="$EXTRA_DOMAINS" \
               EMAIL="$EMAIL" REDIRECT="$REDIRECT" LE_STAGING="$LE_STAGING" \
               bash "${BASH_SOURCE[0]}" "$@"
  fi
  die "Please run as root (certbot writes to /etc/letsencrypt and /etc/nginx)."
fi

# --- Sanity checks --------------------------------------------------------
command -v nginx >/dev/null 2>&1 || \
  die "nginx is not installed. Run setup-nginx.sh (or a wrapper) first."

case "$SERVER_NAME" in
  _|localhost|*.local|hepeer.local)
    die "SERVER_NAME='$SERVER_NAME' is not a public domain. Let's Encrypt can
        only issue certs for a real, DNS-resolvable name. Set SERVER_NAME to a
        domain whose A/AAAA record points at this host, e.g.
        sudo SERVER_NAME=www.hepeer.com ./inizio/setup-https.sh" ;;
esac

# --- Install certbot + the nginx plugin -----------------------------------
need_certbot=1
if command -v certbot >/dev/null 2>&1; then
  # The nginx plugin must also be present.
  if certbot plugins 2>/dev/null | grep -q nginx; then
    need_certbot=0
    log "certbot already installed: $(certbot --version 2>&1)"
  else
    warn "certbot found but the nginx plugin is missing — installing it."
  fi
fi

if [[ "$need_certbot" -eq 1 ]]; then
  log "Installing certbot + nginx plugin…"
  if   command -v apt-get >/dev/null 2>&1; then
    apt-get update -qq && apt-get install -y certbot python3-certbot-nginx
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y certbot python3-certbot-nginx
  elif command -v yum >/dev/null 2>&1; then
    yum install -y certbot python3-certbot-nginx
  elif command -v zypper >/dev/null 2>&1; then
    zypper install -y certbot python3-certbot-nginx
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm certbot certbot-nginx
  else
    die "Could not find a supported package manager to install certbot.
        Install 'certbot' and its nginx plugin manually, then re-run."
  fi
fi

# --- Build the certbot argument list --------------------------------------
# Collect -d flags for the primary name plus any extra SANs.
domain_args=(-d "$SERVER_NAME")
# EXTRA_DOMAINS may be space- and/or comma-separated.
for d in ${EXTRA_DOMAINS//,/ }; do
  [[ -n "$d" ]] && domain_args+=(-d "$d")
done

certbot_args=(--nginx "${domain_args[@]}" --non-interactive --agree-tos
              --keep-until-expiring)

if [[ -n "$EMAIL" ]]; then
  certbot_args+=(-m "$EMAIL")
else
  warn "No EMAIL set — registering without one. You won't get expiry warnings."
  certbot_args+=(--register-unsafely-without-email)
fi

if [[ "$REDIRECT" == "1" ]]; then
  certbot_args+=(--redirect)
else
  certbot_args+=(--no-redirect)
fi

if [[ "$LE_STAGING" == "1" ]]; then
  warn "Using Let's Encrypt STAGING — the issued cert will NOT be trusted by browsers."
  certbot_args+=(--staging)
fi

# --- Obtain & install the certificate -------------------------------------
log "Requesting a certificate for: ${SERVER_NAME}${EXTRA_DOMAINS:+ (+ $EXTRA_DOMAINS)}"
certbot "${certbot_args[@]}"

# --- Make sure automatic renewal is active --------------------------------
# certbot packages ship either a systemd timer or a cron job that runs
# `certbot renew` twice daily. Nudge the timer on if systemd is in charge.
if command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files 2>/dev/null | grep -q '^certbot.timer'; then
    systemctl enable --now certbot.timer >/dev/null 2>&1 || true
    log "Automatic renewal is handled by the certbot systemd timer."
  else
    log "Renewal is handled by certbot's packaged cron job."
  fi
fi

# Prove that renewal works end-to-end without touching the live cert.
log "Verifying renewal configuration (dry run)…"
if certbot renew --dry-run; then
  log "Renewal dry-run succeeded."
else
  warn "Renewal dry-run failed — investigate before the cert expires."
fi

# --- Done -----------------------------------------------------------------
log "HTTPS is enabled for ${SERVER_NAME}."
printf '    Visit:  https://%s/plans.html\n' "$SERVER_NAME"
