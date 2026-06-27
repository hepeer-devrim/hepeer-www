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

> Make sure each host's DNS A/AAAA record points at the right machine, and that
> ports 80/443 are open. For HTTPS run `sudo certbot --nginx -d www.hepeer.com`
> (or `-d staging-www.hepeer.com`) afterwards.

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

| Variable      | Default        | Description                                  |
| ------------- | -------------- | -------------------------------------------- |
| `SERVER_NAME` | `hepeer.local` | Domain to serve on. Use `_` for catch-all.   |
| `LISTEN_PORT` | `80`           | HTTP port to listen on.                      |
| `WEB_ROOT`    | repo root      | Directory to serve.                          |
| `SITE_NAME`   | `hepeer`       | nginx site / config file name.               |

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
- HTTPS is out of scope here — for a public domain, run
  [`certbot --nginx`](https://certbot.eff.org/) after this script.
