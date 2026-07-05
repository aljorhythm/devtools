---
name: gather-evidence
description: "Capture screenshots of a running web app with Playwright and upload them as PR/MR evidence that renders inline — even in private repos — via Cloudinary. Use when asked to screenshot, capture, gather evidence, or add screenshots to a PR."
compatibility: "Requires curl, python3, and a Chromium/Playwright install. Signed uploads also need openssl. Needs a Cloudinary account (credentials supplied via env)."
---

# Gather Evidence — Screenshots for PRs

> **Skill home / raising changes.** This skill lives in
> [`aljorhythm/devtools` → `skills/gather-evidence`](https://github.com/aljorhythm/devtools/tree/master/skills/gather-evidence)
> and is installed into `~/.claude/skills/` from there. **Raise any change as a PR
> to that repo** — not to a project that merely uses the skill. (Edits in a
> consuming repo's checkout are local only and get overwritten on the next sync.)

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

## Pick a target: prefer the deployed preview URL

Before building anything locally, check whether the PR already has a **deployed
preview / ephemeral environment** — most CI setups post its URL as a PR comment
(e.g. `https://server-pull-request-<n>.up.railway.app`, a Vercel/Netlify preview,
etc.). **Screenshot that URL directly.** It is the real, running build wired to a
real backend and real WebSocket, so:

- no local build, no preview server, no `page.route()` HTTP mocks, and no
  `FakeWebSocket` stub — you just drive the actual app;
- the evidence shows production-representative behaviour, not a mock, which is far
  more convincing to a reviewer;
- you reach app state through the real UI (log in, create/join a room, start a
  game) instead of faking API responses.

```js
await page.goto('https://server-pull-request-306.up.railway.app/')
// then interact for real: fill the login form, click "Host a game", etc.
```

Caveats: wait for the deploy to be **ready** (the preview-env PR comment usually
announces it; confirm the commit SHA matches the PR head) and for navigations to
settle (`await page.waitForLoadState('networkidle')`). Some flows still need a
seeded fixture — if the real backend can't reach the state you want to show, fall
back to a local build with mocks (below). Don't screenshot a stale preview from an
older commit.

## Taking Screenshots

Point Playwright at your chosen target — the deployed preview URL above, or a
local `http://localhost:4173` build when you need mocks.

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

Each call verifies the asset is a public `200 image/*` (aborting if not — a
private/misconfigured upload silently fails to render) and prints a Markdown
image tag. A third arg overrides the Cloudinary folder.

### Put the evidence in the PR/MR DESCRIPTION, not a comment

**Always attempt the description first.** The description is where a reviewer
looks; a comment scrolls away. Edit the PR/MR body to add (or update) an
`## Evidence` section. Re-running to add more shots means editing that same
section again. **Only fall back to a comment** if the body genuinely can't be
edited (e.g. you lack write on the PR). When you open the PR yourself, put the
`## Evidence` section straight into the body at creation time.

The description lives in the **`body`** field of the Pull Request. Pick whatever
you have: the `update_pull_request` MCP tool, `gh pr edit <n> --body -`, or the
raw REST API — a repo-scoped PAT (`repo` / `pull_requests:write`) works even when
`gh`'s Actions access is blocked. GET current body first so you append, not
clobber:

```bash
# read the current description
curl -sS -H "Authorization: Bearer $GH_TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/{owner}/{repo}/pulls/{n} | jq -r .body
# set the new description (PRs are issues, so the issues endpoint also works)
curl -sS -X PATCH -H "Authorization: Bearer $GH_TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/{owner}/{repo}/pulls/{n} \
  -d "$(jq -n --arg b "$BODY" '{body:$b}')"
```

For GitLab, edit the MR description (`PUT /projects/:id/merge_requests/:iid`,
`description` field).

### Make sure it actually renders

- Use the **Markdown `![alt](url)`** form on its **own line** — this is the
  canonical GitHub image syntax (proxied via camo). **Do NOT use a raw `<img>`
  tag on GitHub** — GitHub HTML-escapes it and it shows as literal text
  (`&lt;img …&gt;`) in a grey box, not an image. (`<img>` renders on GitLab, so
  it's fine for a real MR — GitHub is the one that escapes it.)
- Never put the tag inside a **table cell or a list item** — burying an image in
  a Markdown table is a common reason a valid URL renders as nothing. One tag per
  line, blank line around it.
- The URL must open publicly in a browser as the raw image (the script checks
  this: a `200 image/*`). If it doesn't, the upload is private — fix the
  Cloudinary delivery, don't just paste a dead tag.
- After posting, **confirm it rendered** rather than assuming. Two failure
  signatures mean the GitHub org/instance has its **external image proxy (camo)
  disabled** — no external URL (Cloudinary or any) will embed:
  - `![alt](url)` renders as a **plain link** (the alt text, blue/underlined),
    not an image; and
  - a raw `<img>` shows as **escaped literal text** (`&lt;img …&gt;`).
  When you see this, stop retrying external URLs. The only thing GitHub embeds is
  its **own** attachments: drag-drop the file into the PR editor → a
  `github.com/user-attachments/…` URL (this needs the web UI, so a headless agent
  usually can't). Practical fallback: **hand the image files to the user** (send
  them the files, or `docs/evidence/…` in the branch) and ask them to drag-drop,
  and leave the Cloudinary `![]()` link in as a clickable degradation.

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

## Related skills

- **ship-changes** — commit and push the PR once evidence is added.
