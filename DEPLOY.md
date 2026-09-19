# Deploying oyinloye.com

A static site served by nginx in a Docker container, shipped to the homelab
with [Kamal](https://kamal-deploy.org) — the same flow as kidstercorner, minus
the database, volumes, and app secrets.

## Layout

- `site/` — the actual web root (`index.html`, `graveyard.html`, `images/`).
  **Edit here.** It's what gets copied into the image.
- `Dockerfile` — `nginx:1.27-alpine` + `site/` + `nginx.conf`.
- `nginx.conf` — serves `:80`, gzips text, caches images 30d, revalidates HTML.
- `config/deploy.yml` — Kamal config (single production destination).
- `.kamal/secrets` — pulls `KAMAL_REGISTRY_PASSWORD` from `.env.production`.
- `.env.production` — **gitignored**; holds your Docker Hub token.

> The `redesign/` folder (design options v1–v3 + picker) is kept for reference
> only and is not shipped. `site/index.html` is the promoted copy of the
> chosen "Shipping Log" design.

## One-time setup

1. Put your Docker Hub access token in `.env.production`:
   ```
   KAMAL_REGISTRY_PASSWORD=<your-docker-hub-token>
   ```
2. Make sure the Cloudflare tunnel on the homelab routes the new hostnames to
   the shared kamal-proxy (`:80`), exactly like kidstercorner:
   - **DNS:** create the tunnel CNAMEs (proxied):
     ```
     cloudflared tunnel route dns <your-tunnel> oyinloye.com
     cloudflared tunnel route dns <your-tunnel> www.oyinloye.com
     ```
   - **Ingress:** add `oyinloye.com` and `www.oyinloye.com` to the tunnel's
     ingress rules, pointing at the same service URL kidstercorner uses
     (the homelab kamal-proxy on `http://<host>:80`).

   kamal-proxy already routes by Host header, and both hostnames are claimed in
   `config/deploy.yml`, so no proxy change is needed — just the tunnel + DNS.

## Ship it

First deploy (registers the service, builds, pushes, boots):
```
kamal setup
```

Every update after that:
```
kamal deploy
```

Useful:
```
kamal logs -f      # tail nginx logs
kamal app details  # container status
kamal rollback     # revert to the previous image
```

## Making changes

Edit files under `site/`, commit, then `kamal deploy`. Kamal versions each
image by git SHA, so commit before deploying to keep versions meaningful.
