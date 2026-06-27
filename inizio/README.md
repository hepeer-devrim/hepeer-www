# inizio — nginx setup for the Hepeer website

The Hepeer site is a set of **static** HTML/CSS/JS files (`index.html`,
`plans.html`, `about.html`, `assets/styles.css`, `assets/site.js`, …). These scripts configure
[nginx](https://nginx.org/) to serve them — no build step or app server needed.

## Per-host setup (run the right one on the right box)

The same content is served on two hosts. Each has a dedicated wrapper script —
run the matching one on each machine:

```bash
# On the production host (serves www.hepeer.com):
sudo ./inizio/setup-production.sh

# On the staging host (serves staging-www.hepeer.com):
sudo ./inizio/setup-staging.sh
```

| Script                 | Domain                     | nginx site name     |
| ---------------------- | -------------------------- | ------------------- |
| `setup-production.sh`  | `www.hepeer.com`           | `hepeer-production` |
| `setup-staging.sh`     | `staging-www.hepeer.com`   | `hepeer-staging`    |

Both are thin wrappers around `setup-nginx.sh` (below) with the right
`SERVER_NAME` baked in. Each will:

1. Install nginx if it isn't already present.
2. Generate an nginx server block from [`hepeer.conf.template`](./hepeer.conf.template)
   pointing at this repository's files.
3. Enable the site and reload nginx.
4. **Obtain a Let's Encrypt certificate and turn on HTTPS** (on by default).

> Make sure each host's DNS A/AAAA record points at the right machine, and that
> ports 80/443 are open.

## HTTPS (Let's Encrypt)

**HTTPS is enabled by default** on both the production and staging hosts. After
the HTTP site is up, the wrappers hand off to [`setup-https.sh`](./setup-https.sh),
which installs certbot, obtains a Let's Encrypt certificate via the nginx
plugin, switches on an HTTP→HTTPS redirect, and verifies automatic renewal.

```bash
# Production — HTTP + HTTPS (default):
sudo ./inizio/setup-production.sh

# Staging — HTTP + HTTPS (default):
sudo ./inizio/setup-staging.sh

# Opt out (HTTP only) if you ever need to:
sudo ENABLE_HTTPS=0 ./inizio/setup-production.sh
```

For the **generic** `setup-nginx.sh`, HTTPS is also on by default but is
**skipped automatically** for non-public names (`_`, `localhost`, `*.local`,
including the `hepeer.local` default) since Let's Encrypt can't certify them —
so local setups keep working with no extra flags.

You can also run the HTTPS step on its own against an already-configured HTTP
site:

```bash
sudo SERVER_NAME=www.hepeer.com EMAIL=admin@hepeer.com ./inizio/setup-https.sh
```

| Variable        | Default            | Description                                         |
| --------------- | ------------------ | --------------------------------------------------- |
| `SERVER_NAME`   | `hepeer.local`     | Public domain to certify (must resolve to this host). |
| `EXTRA_DOMAINS` | _(none)_           | Extra names on the same cert, e.g. `hepeer.com`.    |
| `EMAIL`         | `admin@hepeer.com` | Contact address for expiry notices.                 |
| `REDIRECT`      | `1`                | Force HTTP→HTTPS redirect (`0` to keep plain HTTP). |
| `LE_STAGING`    | `0`                | Use Let's Encrypt's staging env for testing.        |

**Prerequisites for issuance:** the domain's DNS A/AAAA record must already
point at this host, and ports **80** and **443** must be reachable from the
internet (certbot proves control via an HTTP-01 challenge on port 80). HTTPS
cannot be issued for `_`, `localhost`, or `*.local` names — Let's Encrypt only
certifies real, resolvable domains.

Renewal is automatic (certbot's systemd timer or cron job runs `certbot renew`
twice daily); the setup script ends with a `--dry-run` to confirm it works.
To test issuance without burning rate limits, pass `LE_STAGING=1` (the cert
won't be browser-trusted).

## Generic / local setup

```bash
sudo ./inizio/setup-nginx.sh
```

By default the site answers on `http://hepeer.local/`. For a local domain, add
it to your hosts file:

```bash
echo "127.0.0.1  hepeer.local" | sudo tee -a /etc/hosts
```

Then open <http://hepeer.local/plans.html>.

## Configuration

Override any of these via environment variables:

| Variable       | Default        | Description                                            |
| -------------- | -------------- | ----------------------------------------------------- |
| `SERVER_NAME`  | `hepeer.local` | Domain to serve on. Use `_` for catch-all.            |
| `LISTEN_PORT`  | `80`           | HTTP port to listen on.                               |
| `WEB_ROOT`     | repo root      | Directory to serve.                                   |
| `SITE_NAME`    | `hepeer`       | nginx site / config file name.                        |
| `ENABLE_HTTPS` | `1`            | Obtain a Let's Encrypt cert & enable HTTPS. `0` to skip. Auto-skipped for non-public names. |
| `EMAIL`        | _(none)_       | Contact email for Let's Encrypt when HTTPS runs.      |

Examples:

```bash
# Serve as the default server on port 8080 (no hosts entry needed):
sudo SERVER_NAME=_ LISTEN_PORT=8080 ./inizio/setup-nginx.sh

# Serve a real domain:
sudo SERVER_NAME=hepeer.example.com ./inizio/setup-nginx.sh
```

## Removing the site

Pass the site name that matches the host you set up:

```bash
# Production:
sudo SITE_NAME=hepeer-production ./inizio/teardown-nginx.sh

# Staging:
sudo SITE_NAME=hepeer-staging ./inizio/teardown-nginx.sh

# Generic/local (default SITE_NAME=hepeer):
sudo ./inizio/teardown-nginx.sh
```

Removes the generated nginx config and reloads. It does **not** uninstall nginx
or delete any website files.

## Notes

- The config serves files straight from this repo. On a real server you may
  prefer to copy the site into `/var/www/hepeer` and point `WEB_ROOT` there.
- `try_files` makes extension-less URLs work (`/plans` → `/plans.html`).
- HTTPS is handled by [`setup-https.sh`](./setup-https.sh) (Let's Encrypt via
  the certbot nginx plugin) — see the **HTTPS** section above.
- Tearing the site down with `teardown-nginx.sh` removes the nginx config but
  leaves issued certificates under `/etc/letsencrypt`. To drop a cert as well,
  run `sudo certbot delete --cert-name <domain>`.
