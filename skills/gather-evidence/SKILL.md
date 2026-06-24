---
name: gather-evidence
description: "Capture screenshots of a running web app with Playwright and upload them as PR/MR evidence that renders inline — even in private repos — via Cloudinary. Use when asked to screenshot, capture, gather evidence, or add screenshots to a PR."
compatibility: "Requires curl, python3, and a Chromium/Playwright install. Signed uploads also need openssl. Needs a Cloudinary account (credentials supplied via env)."
---

# Gather Evidence — Screenshots for PRs

Screenshots are good practice for every PR that touches the UI. Capture with
Playwright, then upload with the bundled `upload-evidence.sh` — it posts to
Cloudinary and prints a Markdown image tag whose `secure_url` renders inline in
a PR/MR, **including private repos** (GitHub's camo proxy can fetch a Cloudinary
URL; it cannot fetch a private repo's `…/raw/…` link).

**Reusable across repos.** This skill is self-contained — it makes no assumption
about the host project's build system. Install it once at user scope
(`~/.claude/skills/gather-evidence/`) and it works in any repo; the only
per-machine config is the Cloudinary env vars (below). Because the working
directory will be the *target* repo, invoke the uploader by its path inside the
skill, not a cwd-relative one — set `SKILL_DIR` once:

```bash
SKILL_DIR=~/.claude/skills/gather-evidence    # or <repo>/.claude/skills/gather-evidence
```

Why Cloudinary (not committing to the repo, not catbox): a private repo's
`…/raw/…` link does **not** render in a PR (camo can't read private content);
catbox-style anonymous public hosts are commonly blocked by sandbox policy.
Cloudinary returns a `secure_url` that renders. The URL is public-but-unguessable
(not listed/indexed) — a truly signed/private URL would not render inline, which
is inherent to embedding images in Markdown. Don't upload secrets or sensitive
data.

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

Credentials come from the **environment** — never inline them in a script or
commit them. Pick one of two modes:

```bash
export CLOUDINARY_CLOUD_NAME=<cloud>

# Signed mode — uses your API key + secret:
export CLOUDINARY_API_KEY=<key>
export CLOUDINARY_API_SECRET=<secret>

# …OR unsigned mode — uses an unsigned upload preset, no secret needed (preferred
# if you'd rather not expose the secret at all). Create the preset in the
# Cloudinary console: Settings → Upload → Upload presets → Add, Signing = Unsigned.
# export CLOUDINARY_UPLOAD_PRESET=<preset>

# optional: target folder in your account (default: pr-evidence)
# export EVIDENCE_FOLDER=pr-evidence

"$SKILL_DIR/scripts/upload-evidence.sh" .screenshots/home.png "Home page"
# => ![Home page](https://res.cloudinary.com/<cloud>/image/upload/v1/pr-evidence/home.png)
```

Each call prints a Markdown image tag. Paste the tags into the PR body under a
`## Screenshots` section. A third arg overrides the Cloudinary folder.

> **Secret hygiene:** the API secret grants account-wide admin. Prefer unsigned
> mode where you can. If you use signed mode, keep the secret in env secrets
> only, and rotate it immediately if it's ever pasted into a chat/log/issue.

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
![Home page](https://res.cloudinary.com/<cloud>/image/upload/v1/pr-evidence/home.png)
```

If the evidence is a curl response or log output rather than an image, paste it
directly in the PR body as a fenced code block.

---

## Contributing

Improvements to this skill should be raised as a PR against the `master` branch
of [`aljorhythm/devtools`](https://github.com/aljorhythm/devtools).

---

## Related skills

- **ship-changes** — commit and push the PR once evidence is added.
