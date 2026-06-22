---
name: gather-evidence
description: "Capture screenshots of a running web app with Playwright and upload them as PR/MR evidence that renders inline — even in private repos. Hosts assets on a file server you control (private + archivable). Use when asked to screenshot, capture, gather evidence, or add screenshots to a PR."
compatibility: "Requires curl and a Chromium/Playwright install. Optional: a self-hosted file server (dufs/nginx/Caddy) for inline-rendering uploads — see Server setup."
---

# Gather Evidence — Screenshots for PRs

Screenshots are good practice for every PR that touches the UI. Capture with
Playwright, then upload with the bundled `upload-evidence.sh` — its URLs render
inline in a PR/MR, **including private repos**, because the asset is served from
a file server you control rather than from the (unreadable-by-camo) private repo.

**Reusable across repos.** This skill is self-contained — it makes no assumption
about the host project's build system. Install it once at user scope
(`~/.claude/skills/gather-evidence/`) and it works in any repo; the only
per-machine config is three env vars (below). Because the working directory will
be the *target* repo, invoke the uploader by its path inside the skill, not a
cwd-relative one — set `SKILL_DIR` once:

```bash
SKILL_DIR=~/.claude/skills/gather-evidence    # or <repo>/.claude/skills/gather-evidence
```

Two requirements this skill is built around:

1. **Viewable from the PR** — GitHub's image proxy (camo) only renders a URL it
   can fetch anonymously, so the server serves files back at a
   public-but-unguessable HTTPS path.
2. **Archivable** — every upload is a real file in a directory tree on your box,
   browsable and backup-able forever.

## Taking Screenshots

If the `playwright` CLI is installed, use it directly:

```bash
npx playwright screenshot --viewport-size=1280,800 http://localhost:4173 .screenshots/home.png
```

> **If Playwright isn't installed** (common in remote sandboxes), drive the
> bundled Chromium instead of fighting the install. Install `playwright-core`
> into a temp dir so the repo stays clean, and point it at a Chromium already in
> the image:
>
> ```bash
> npm install --prefix /tmp/pw playwright-core
> ls /opt/pw-browsers          # find the chromium-<rev> dir (version varies)
> ```
> ```js
> // CJS; from an ESM .mjs use: import pw from '…'; const { chromium } = pw
> const { chromium } = require('/tmp/pw/node_modules/playwright-core')
> const browser = await chromium.launch({
>   executablePath: '/opt/pw-browsers/chromium-<rev>/chrome-linux64/chrome',
>   args: ['--no-sandbox'],
> })
> const page = await browser.newPage({ viewport: { width: 1280, height: 800 } })
> await page.goto('http://localhost:4173')
> await page.screenshot({ path: '.screenshots/home.png' })
> await browser.close()
> ```
> From there the normal Playwright API is available: `page.route(...)` to mock
> HTTP, `addInitScript(...)` to seed WebSocket/other globals before the page
> loads, `setViewportSize(...)` for mobile, etc.

Common mobile viewports: iPhone 13/14 `390×844`, iPhone SE `375×667`,
Pixel 7 `412×915`, iPad `768×1024`.

### Pages that require login / non-HTTP state

- **Login:** reuse one browser context — fill the form and submit before
  navigating to protected routes.
- **WebSocket / other non-HTTP transports:** `page.route()` only intercepts
  HTTP. Stub the global **before** the page loads with `addInitScript` so it is
  already replaced when the app mounts:

```js
await page.addInitScript(() => {
  class FakeWebSocket {
    constructor() {
      this.readyState = 1
      setTimeout(() => {
        this.onmessage?.({ data: JSON.stringify({ type: 'members', data: [{ id: 'u1', name: 'Alice' }] }) })
      }, 100)
    }
    send() {}
    close() {}
  }
  window.WebSocket = FakeWebSocket
})
```

## Uploading and adding to the PR

```bash
export EVIDENCE_BASE_URL=https://evidence.example.com
export EVIDENCE_AUTH='Bearer <token>'     # full Authorization header value
# optional: export EVIDENCE_PUBLIC_URL=https://evidence.example.com

"$SKILL_DIR/scripts/upload-evidence.sh" .screenshots/home.png "Home page"
# => ![Home page](https://evidence.example.com/pr-evidence/20260622-a1b2c3-home.png)
```

Each call prints a Markdown image tag and stores the file under
`pr-evidence/<date>-<rand>-<name>` on the server (override the path with a third
arg). Paste the tags into the PR body under a `## Screenshots` section.

The script uploads with `curl -T` and an `Authorization` header — no SSH, no
third-party account, works from sandboxes where only HTTPS (443) is open. The
token is a hardcoded string; treat it as a write capability and keep it in env
secrets, never committed. Do not upload credentials or sensitive data.

## Recording steps taken

Document the exact steps alongside the evidence so a reviewer can reproduce the
check and trust it wasn't fabricated. Add an `## Evidence` section:

```md
## Evidence

**Steps taken:**
1. Started the preview server on http://localhost:4173
2. Captured the home + rooms pages with Playwright
3. `"$SKILL_DIR/scripts/upload-evidence.sh" .screenshots/home.png "Home page"`

**Screenshots:**
![Home page](https://evidence.example.com/pr-evidence/20260622-a1b2c3-home.png)
```

If the evidence is a curl response or log output rather than an image, paste it
directly in the PR body as a fenced code block.

---

## Server setup (one-time, on a VM you control)

A ready-to-deploy Docker Compose stack lives in [`server/`](./server/) next to
this skill — **dufs** (authenticated HTTP `PUT` uploads) behind **Caddy** (auto
TLS + bearer-gated writes, public reads). On a fresh DigitalOcean droplet (or any
VM) with Docker:

```bash
cd server
cp .env.example .env     # set EVIDENCE_DOMAIN + a strong EVIDENCE_TOKEN
docker compose up -d
```

See [`server/README.md`](./server/README.md) for the full walkthrough,
verification curls, and operating notes. Key points:

- **TLS without a domain:** Caddy needs a DNS name for a Let's Encrypt cert
  (camo rejects self-signed). Bare IP only? Use the `nip.io` trick — set
  `EVIDENCE_DOMAIN=evidence.<dashed-ip>.nip.io` (e.g. `evidence.203-0-113-7.nip.io`).
- **Privacy:** writes need the token; reads are public-but-unguessable (random
  path component) so camo can render them. That tradeoff is inherent to
  embedding images in Markdown — a truly auth-gated URL would not render inline.
- Then point the uploader at it: `EVIDENCE_BASE_URL=https://$EVIDENCE_DOMAIN`
  and `EVIDENCE_AUTH="Bearer $EVIDENCE_TOKEN"`.

---

## Related skills

- **ship-changes** — commit and push the PR once evidence is added.
