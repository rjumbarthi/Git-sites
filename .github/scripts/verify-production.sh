#!/usr/bin/env bash
# Verify live production URLs for apps.port443.llc (GitHub Pages).
# Source of truth is production, not the workspace checkout.
set -euo pipefail

BASE="https://apps.port443.llc"
MAX_ATTEMPTS=12
SLEEP_SECS=15

wait_for_pages() {
  local probe="${BASE}/"
  echo "Waiting for GitHub Pages to serve ${probe} ..."
  for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
    if curl -sf -o /dev/null --max-time 20 "$probe"; then
      echo "Pages is responding (attempt ${attempt}/${MAX_ATTEMPTS})."
      return 0
    fi
    echo "Not ready yet (attempt ${attempt}/${MAX_ATTEMPTS}); sleeping ${SLEEP_SECS}s ..."
    sleep "$SLEEP_SECS"
  done
  echo "Timed out waiting for GitHub Pages."
  return 1
}

verify_root() {
  local url="${BASE}/"
  local code body

  code="$(curl -sS -o /tmp/root-body.html -w '%{http_code}' --max-time 30 "$url")"

  if [[ "$code" != "200" ]]; then
    echo "FAIL ${url} — unexpected HTTP ${code}"
    exit 1
  fi

  body="$(cat /tmp/root-body.html)"
  if ! grep -q '/taskera/' <<<"$body" || ! grep -q '/kaal/' <<<"$body"; then
    echo "FAIL ${url} — HTTP 200 but body does not link both /taskera/ and /kaal/"
    exit 1
  fi
  echo "OK ${url} — HTTP 200, links both apps"
}

verify_url() {
  local url="$1"
  local code effective

  code="$(curl -sS -o /dev/null -w '%{http_code}' -L --max-redirs 10 --max-time 30 "$url")"
  effective="$(curl -sS -o /dev/null -w '%{url_effective}' -L --max-redirs 10 --max-time 30 "$url")"

  if [[ "$code" != "200" ]]; then
    echo "FAIL ${url} — HTTP ${code} (effective: ${effective})"
    exit 1
  fi
  echo "OK ${url} — HTTP ${code}"
}

wait_for_pages
verify_root
verify_url "${BASE}/taskera/"
verify_url "${BASE}/taskera/privacy"
verify_url "${BASE}/taskera/terms"
verify_url "${BASE}/taskera/support"
verify_url "${BASE}/taskera/delete"
verify_url "${BASE}/kaal/"
verify_url "${BASE}/kaal/privacy"
verify_url "${BASE}/kaal/terms"
verify_url "${BASE}/kaal/support"
verify_url "${BASE}/kaal/delete"

echo "All production URLs verified."
