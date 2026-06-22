# Evidence file server

A self-hosted home for PR/MR evidence (screenshots, short clips). Used by the
`gather-evidence` skill's `upload-evidence.sh`. Two containers:

- **dufs** — serves `./data` and accepts authenticated HTTP `PUT` uploads.
- **Caddy** — terminates TLS (auto Let's Encrypt) and gates **writes** behind a
  hardcoded bearer token. **Reads stay public** so GitHub's image proxy (camo)
  can render the images inline in a PR — the URLs are public-but-unguessable
  (random path component), not listed or enumerable.

```
client ──PUT (Authorization: Bearer …)──► Caddy :443 ──► dufs :5000 ──► ./data
camo   ──GET (no auth)───────────────────► Caddy :443 ──► dufs :5000 ──► ./data
```

## Deploy (DigitalOcean droplet or any VM)

Prereqs: a VM with Docker + Compose, ports **80** and **443** open, and a DNS
name pointing at it (or use the `nip.io` trick below).

```bash
# 1. Get these files onto the VM (clone devtools, or scp this server/ dir)
git clone https://github.com/aljorhythm/devtools
cd devtools/skills/gather-evidence/server

# 2. Configure
cp .env.example .env
# edit .env: set EVIDENCE_DOMAIN and a strong EVIDENCE_TOKEN (openssl rand -hex 24)

# 3. Launch
docker compose up -d
docker compose logs -f caddy   # watch the TLS cert get issued
```

**No domain?** Caddy needs a DNS name for a Let's Encrypt cert (camo rejects
self-signed). Use [`nip.io`](https://nip.io): if your droplet IP is `203.0.113.7`,
set `EVIDENCE_DOMAIN=evidence.203-0-113-7.nip.io` — it resolves to that IP and
gets a valid cert, no DNS setup required.

## Verify

```bash
DOMAIN=evidence.example.com
TOKEN=...                                  # the EVIDENCE_TOKEN you set
echo hello > /tmp/t.txt

# write WITHOUT token -> 401
curl -i -T /tmp/t.txt https://$DOMAIN/pr-evidence/t.txt

# write WITH token -> 201
curl -i -H "Authorization: Bearer $TOKEN" -T /tmp/t.txt https://$DOMAIN/pr-evidence/t.txt

# read back WITHOUT token -> 200 (this is what camo does)
curl -i https://$DOMAIN/pr-evidence/t.txt
```

## Point the uploader at it

In the environment where you run `gather-evidence`:

```bash
export EVIDENCE_BASE_URL=https://evidence.example.com
export EVIDENCE_AUTH="Bearer <EVIDENCE_TOKEN>"   # full Authorization header value
# optional: EVIDENCE_PUBLIC_URL if reads are served from a different host
```

## Operating notes

- **Backups / archive:** everything lives in `./data` — back it up; that's the
  permanent evidence archive.
- **Rotating the token:** change `EVIDENCE_TOKEN` in `.env`, `docker compose up -d`
  to recreate Caddy, and update `EVIDENCE_AUTH` wherever the uploader runs.
- **Storage hygiene:** prune old files under `./data/pr-evidence` on whatever
  retention you want; URLs already in merged PRs will 404 once pruned.
- `.env` and `data/` are gitignored — never commit secrets or uploads.
