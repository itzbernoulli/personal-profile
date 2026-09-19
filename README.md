# oyinloye.com

Personal profile site for Ayodeji Oyinloye — a static site served by nginx and
deployed to the homelab with [Kamal](https://kamal-deploy.org).

## Structure

- **`site/`** — the web root that ships. Edit here.
  - `index.html` — the profile ("Shipping Log" design)
  - `graveyard.html` — retired projects + their screenshots
  - `images/` — assets used by both pages
- `Dockerfile` / `nginx.conf` — the nginx image
- `config/deploy.yml` / `.kamal/` — Kamal deploy config
- `redesign/` — alternate design explorations (v1–v3), kept for reference only

## Develop

Open `site/index.html` in a browser. No build step.

## Deploy

See [`DEPLOY.md`](DEPLOY.md). Short version:

```
kamal setup      # first time
kamal deploy     # every update after
```
