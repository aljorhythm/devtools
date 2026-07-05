#!/usr/bin/env bash
# Upload a PR-evidence asset (screenshot / image / short clip) to Cloudinary and
# print a Markdown image tag whose URL renders inline in a GitHub/GitLab PR/MR —
# including in PRIVATE repos (GitHub's camo proxy can fetch a Cloudinary
# secure_url; it cannot fetch a private repo's …/raw/… link).
#
# Credentials come from the ENVIRONMENT — never inlined, never committed.
# Two modes (pick one):
#
#   Signed (uses your API key + secret):
#     CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET
#
#   Unsigned (uses an unsigned upload preset; no secret needed — preferred if you
#   don't want the secret in the environment at all):
#     CLOUDINARY_CLOUD_NAME, CLOUDINARY_UPLOAD_PRESET
#
# Optional:
#   EVIDENCE_FOLDER   target folder in your Cloudinary account (default: pr-evidence)
#
# Usage:
#   upload-evidence.sh <file> [caption] [folder]
#
# Output (stdout): a Markdown image tag, e.g.
#   ![Lobby hub](https://res.cloudinary.com/<cloud>/image/upload/v1/pr-evidence/lobby.png)
#
# Requires: curl, python3, and (signed mode only) openssl.
set -euo pipefail

FILE="${1:-}"
CAPTION="${2:-screenshot}"
FOLDER="${3:-${EVIDENCE_FOLDER:-pr-evidence}}"

if [[ -z "$FILE" ]]; then
  echo "Usage: $0 <file> [caption] [folder]" >&2
  exit 1
fi
if [[ ! -f "$FILE" ]]; then
  echo "Error: file not found: $FILE" >&2
  exit 1
fi
if [[ -z "${CLOUDINARY_CLOUD_NAME:-}" ]]; then
  echo "Error: set CLOUDINARY_CLOUD_NAME in the env." >&2
  exit 1
fi

ENDPOINT="https://api.cloudinary.com/v1_1/${CLOUDINARY_CLOUD_NAME}/auto/upload"

if [[ -n "${CLOUDINARY_UPLOAD_PRESET:-}" ]]; then
  # --- Unsigned upload: no secret involved. ---
  RESP=$(curl -sf --max-time 60 "$ENDPOINT" \
    -F "file=@${FILE}" \
    -F "folder=${FOLDER}" \
    -F "upload_preset=${CLOUDINARY_UPLOAD_PRESET}") || {
    echo "Error: unsigned upload failed (network/policy or bad preset)." >&2
    exit 1
  }
elif [[ -n "${CLOUDINARY_API_KEY:-}" && -n "${CLOUDINARY_API_SECRET:-}" ]]; then
  # --- Signed upload: sign the (alphabetically sorted) params with the secret. ---
  # Signature = sha1( "folder=<f>&timestamp=<ts>" + api_secret ), hex.
  TS=$(date +%s)
  TO_SIGN="folder=${FOLDER}&timestamp=${TS}"
  SIG=$(printf '%s' "${TO_SIGN}${CLOUDINARY_API_SECRET}" | openssl sha1 | awk '{print $NF}')
  RESP=$(curl -sf --max-time 60 "$ENDPOINT" \
    -F "file=@${FILE}" \
    -F "folder=${FOLDER}" \
    -F "timestamp=${TS}" \
    -F "api_key=${CLOUDINARY_API_KEY}" \
    -F "signature=${SIG}") || {
    echo "Error: signed upload failed (network/policy or bad credentials)." >&2
    exit 1
  }
else
  echo "Error: set CLOUDINARY_UPLOAD_PRESET (unsigned) OR CLOUDINARY_API_KEY + CLOUDINARY_API_SECRET (signed)." >&2
  exit 1
fi

URL=$(printf '%s' "$RESP" | python3 -c "import json,sys
try:
    print(json.load(sys.stdin)['secure_url'])
except Exception:
    pass")

if [[ -z "$URL" ]]; then
  echo "Error: no secure_url in response: $RESP" >&2
  exit 1
fi

# Verify the asset is PUBLICLY fetchable as an image — exactly what a PR/MR image
# proxy (GitHub camo, GitLab) needs. A private/authenticated asset returns 401/403
# here and would silently fail to render in the PR; catch it now instead.
read -r CODE CTYPE < <(curl -fsSL -o /dev/null -w '%{http_code} %{content_type}\n' --max-time 30 "$URL" 2>/dev/null || echo "000 -")
if [[ "$CODE" != "200" || "$CTYPE" != image/* ]]; then
  echo "Error: uploaded asset is not publicly renderable (HTTP $CODE, type ${CTYPE:-none})." >&2
  echo "  URL: $URL" >&2
  echo "  It must deliver as a PUBLIC Cloudinary 'upload' asset (not authenticated/private)." >&2
  exit 1
fi

# Canonical form: Markdown `![]()` on its OWN line — never inside a table cell or
# a list item; burying an image in a table is the most common reason a valid URL
# silently fails to render in a PR/MR. Do NOT use a raw <img> tag on GitHub — it
# gets HTML-escaped and shows as literal text (GitLab renders <img> fine).
echo "![${CAPTION}](${URL})"
