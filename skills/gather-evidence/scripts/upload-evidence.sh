#!/usr/bin/env bash
# Upload a PR-evidence asset (screenshot / image / short clip) to a self-hosted
# file server and print a Markdown image tag whose URL renders inline in a
# GitHub or GitLab PR/MR.
#
# Why self-hosted (not Cloudinary / catbox / committing to the repo):
#   - You own the box, so the evidence stays PRIVATE on infrastructure you
#     control — no third-party account, no public anonymous host.
#   - It is still viewable from the PR: GitHub's image proxy (camo) only renders
#     a URL it can fetch anonymously, so the server serves files back over HTTPS
#     at a public-but-unguessable path. (Linking a PRIVATE repo's `…/raw/…` does
#     NOT render in a private-repo PR — camo can't read it.)
#   - It supports archiving: every upload is a real file in a directory tree you
#     can browse / back up forever.
#
# Why a header token (not SSH): uploads often run from CI/sandboxes where
# outbound SSH (port 22) is blocked but HTTPS (443) is allowed. A hardcoded
# bearer-style token in the Authorization header is enough for this low-stakes,
# write-only use. Any server that accepts an authenticated HTTP PUT works
# (dufs, nginx WebDAV, Caddy, SFTPGo, …) — see the "Server setup" appendix in
# SKILL.md for a one-command DigitalOcean/VM recipe.
#
# Usage:
#   upload-evidence.sh <file> [caption] [dest-subpath]
#
# Output (stdout): a Markdown image tag, e.g.
#   ![Lobby hub](https://evidence.example.com/pr-evidence/20260622-a1b2c3-lobby.png)
#
# Required env (set as environment secrets; never commit them):
#   EVIDENCE_BASE_URL    upload endpoint base, e.g. https://evidence.example.com
#   EVIDENCE_AUTH        full Authorization header value, e.g. "Bearer s3cr3t"
# Optional env:
#   EVIDENCE_PUBLIC_URL  base URL files are served from (default: EVIDENCE_BASE_URL)
#   EVIDENCE_DEST_DIR    default subdirectory (default: pr-evidence)
#
# Requires: curl
set -euo pipefail

FILE="${1:-}"
CAPTION="${2:-screenshot}"
DEST="${3:-}"

if [[ -z "$FILE" ]]; then
  echo "Usage: $0 <file> [caption] [dest-subpath]" >&2
  exit 1
fi
if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi
if [[ -z "${EVIDENCE_BASE_URL:-}" || -z "${EVIDENCE_AUTH:-}" ]]; then
  echo "Error: set EVIDENCE_BASE_URL and EVIDENCE_AUTH in the env." >&2
  echo "  EVIDENCE_BASE_URL=https://evidence.example.com" >&2
  echo "  EVIDENCE_AUTH='Bearer <token>'   # full Authorization header value" >&2
  exit 1
fi

# Build a collision-free, unguessable destination path unless one was given.
# A date prefix keeps the archive browsable in time order; a short random token
# makes the URL unguessable so camo can fetch it but it isn't enumerable.
if [[ -z "$DEST" ]]; then
  dir="${EVIDENCE_DEST_DIR:-pr-evidence}"
  base="$(basename "$FILE")"
  rand="$(head -c8 /dev/urandom | od -An -tx1 | tr -d ' \n' | cut -c1-6)"
  DEST="${dir}/$(date +%Y%m%d)-${rand}-${base}"
fi

UPLOAD_URL="${EVIDENCE_BASE_URL%/}/${DEST}"

# PUT uploads the file as-is. -f makes curl fail (non-zero) on HTTP errors so the
# caller doesn't get a Markdown tag pointing at a failed upload.
if ! curl -fsS --max-time 60 -T "$FILE" \
      -H "Authorization: ${EVIDENCE_AUTH}" \
      "$UPLOAD_URL" >/dev/null; then
  echo "Error: upload failed (auth, network, or server). URL: $UPLOAD_URL" >&2
  exit 1
fi

PUBLIC="${EVIDENCE_PUBLIC_URL:-$EVIDENCE_BASE_URL}"
echo "![${CAPTION}](${PUBLIC%/}/${DEST})"
