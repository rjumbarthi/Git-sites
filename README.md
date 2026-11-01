# Git-sites

Static marketing and legal site for **TaskEra — Focus & Task Planner** and **Kaal — Focus & Task Planner**, served on GitHub Pages at [apps.port443.llc](https://apps.port443.llc).

This repository is **web content only** (HTML/CSS). It does not contain either app's mobile or desktop source, APIs, or architecture.

## Live site

| Item | Value |
|------|--------|
| Domain | `apps.port443.llc` (see `CNAME`) |
| Hosting | GitHub Pages |
| Default branch | `main` |
| Repo | [`rjumbarthi/git-sites`](https://github.com/rjumbarthi/git-sites) |

The bare apex domain `port443.llc` is a **separate, existing site** (currently on Netlify) and is out of scope for this repo — this site lives only on the `apps.` subdomain, added specifically so it wouldn't conflict with that apex deployment.

Root `/` is a simple landing page linking to `/taskera/` and `/kaal/`.

## Site map

### TaskEra

| Path | File | Purpose |
|------|------|---------|
| `/taskera/` | `taskera/index.html` | Product landing (what TaskEra does, data stance, Google Calendar note, support contact) |
| `/taskera/support` | `taskera/support/index.html` | Support contact, FAQ (account, Google Calendar, restore purchase, delete, notifications) |
| `/taskera/privacy` | `taskera/privacy/index.html` | Privacy Policy |
| `/taskera/terms` | `taskera/terms/index.html` | Terms of Service |
| `/taskera/delete` | `taskera/delete/index.html` | Account & data deletion (in-app + email request) |
| `/taskera/style.css` | `taskera/style.css` | Shared stylesheet for `/taskera/*` pages |

Footer: © 2026 TaskEra · Maryland, USA, and `taskera_support@port443.llc`.

### Kaal

| Path | File | Purpose |
|------|------|---------|
| `/kaal/` | `kaal/index.html` | Product landing (what Kaal does, data stance, Google Calendar note, support contact) |
| `/kaal/support` | `kaal/support/index.html` | Support contact, FAQ (account, Google Calendar, restore purchase, delete, notifications) |
| `/kaal/privacy` | `kaal/privacy/index.html` | Privacy Policy |
| `/kaal/terms` | `kaal/terms/index.html` | Terms of Service |
| `/kaal/delete` | `kaal/delete/index.html` | Account & data deletion (in-app + email request) |
| `/kaal/style.css` | `kaal/style.css` | Shared stylesheet for `/kaal/*` pages |

Footer: © 2026 Kaal · Maryland, USA, and `kaal_support@port443.llc`.

Both apps share the same layout pattern: top nav (Home / Support / Privacy / Terms / Delete as relevant), footer with contact.

**Content parity:** the Terms/Privacy/Support/Deletion text on both `/taskera/*` and `/kaal/*` is kept in sync with the equivalent screens in each app's own codebase (`lib/screens/legal_screen.dart` in `taskera_app` and `kaal_app`). If you edit one side, mirror the change on the other.

## Other root files

| File | Role |
|------|------|
| `CNAME` | Custom domain: `apps.port443.llc` |
| `.nojekyll` | Disables Jekyll processing on GitHub Pages (serves files as-is) |
| `.pages-rebuild` | Build stamp (e.g. `build: 2026-06-27T14:46:28Z`) — used to trigger or record Pages rebuilds |
| `app-ads.txt` | Ad publisher authorization line for Google (`pub-9013964076288950`) |

## How GitHub Pages is used

1. Content lives as static files on `main`.
2. Pages serves the site; `CNAME` maps **apps.port443.llc** to this Pages site. The DNS `CNAME` record for `apps.port443.llc` points to `rjumbarthi.github.io`, "DNS only" (not proxied) in Cloudflare — proxying it breaks GitHub's TLS cert issuance and DNS verification.
3. `.nojekyll` ensures paths and assets are not rewritten by Jekyll.
4. Update content by editing HTML/CSS and pushing to `main` (or opening a PR). After deploy, verify `/`, `/taskera/`, `/kaal/`, and each app's legal/support routes.

There is no build step in-repo beyond static files. Fonts load from Google Fonts (`Inter`) on both apps' pages.

## Editing

- TaskEra landing copy: `taskera/index.html` · Support FAQ: `taskera/support/index.html` · Legal: `taskera/privacy/index.html`, `taskera/terms/index.html`, `taskera/delete/index.html` · Style: `taskera/style.css`
- Kaal landing copy: `kaal/index.html` · Support FAQ: `kaal/support/index.html` · Legal: `kaal/privacy/index.html`, `kaal/terms/index.html`, `kaal/delete/index.html` · Style: `kaal/style.css`

Keep paths absolute under `/taskera/` or `/kaal/` (e.g. `/kaal/style.css`, `/kaal/privacy`) so they resolve correctly on the custom domain.

## Out of scope (this repo)

- TaskEra / Kaal Android, iOS, or Windows app code and APIs
- Auth, sync, or backend architecture
- Store listing assets beyond what appears on these pages
- The `port443.llc` apex domain (separate Netlify-hosted site)

Document app internals only when they are shipped and sourced from Engineering / Product — not from this site alone.

## Contact

- TaskEra support: [taskera_support@port443.llc](mailto:taskera_support@port443.llc)
- Kaal support: [kaal_support@port443.llc](mailto:kaal_support@port443.llc)

## CI workflows

GitHub Actions under [`.github/workflows/`](.github/workflows/):

| Workflow | Triggers | What it checks |
|----------|----------|----------------|
| **CI (PR)** (`ci-pr.yml`) | Pull requests and pushes to `main` | Required site files exist; [html-proofer](https://github.com/gjtorikian/html-proofer) validates HTML and internal links (external URLs skipped); [stylelint](https://stylelint.io/) parses `taskera/style.css` and `kaal/style.css`. |
| **Verify Deploy** (`verify-deploy.yml`) | Push to `main`, manual **Run workflow** | Waits for GitHub Pages to respond, then HTTP-checks the live production URLs listed below. |

To run production verification manually: **Actions → Verify Deploy → Run workflow**.

## Verify after deploy

After a Pages deploy (or DNS/CNAME change), confirm these return successfully (the **Verify Deploy** workflow checks the same URLs automatically):

1. `https://apps.port443.llc/`
2. `https://apps.port443.llc/taskera/` · `/privacy` · `/terms` · `/support` · `/delete`
3. `https://apps.port443.llc/kaal/` · `/privacy` · `/terms` · `/support` · `/delete`

Optional quick check: `curl -sI https://apps.port443.llc/kaal/ | head -n 1` (expect `200`).
