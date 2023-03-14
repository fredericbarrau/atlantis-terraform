#!/usr/bin/env bash

_exitHandler() {
    docker stop $CONTAINER_ID
}

trap '_exitHandler' INT TERM QUIT

[[ -s .env ]] && source .env

# Get an OAUTH token from the authenticated user
# Will last for 1 hour
# GOOGLE_OAUTH_ACCESS_TOKEN="$(gcloud auth print-access-token)"
#     -e GOOGLE_OAUTH_ACCESS_TOKEN="$GOOGLE_OAUTH_ACCESS_TOKEN" \
CONTAINER_ID=$(docker run -d -p 8070:8080 \
    -v "$PWD/data":/data \
    -v "$PWD/config":/config \
    -e INFRACOST_API_KEY="$INFRACOST_API_TOKEN" \
    -e ATLANTIS_GH_USER="$ATLANTIS_GH_USER" \
    -e ATLANTIS_GH_TOKEN="$ATLANTIS_GH_TOKEN" \
    -e ATLANTIS_GH_WEBHOOK_SECRET="$ATLANTIS_GH_WEBHOOK_SECRET" \
    -e ATLANTIS_REPO_ALLOWLIST="$ATLANTIS_REPO_ALLOWLIST" \
    -e ATLANTIS_ATLANTIS_URL="$ATLANTIS_ATLANTIS_URL" \
    fredericbarrau/atlantis-custom server \
    --config=/config/server-settings.yaml)
docker logs "$CONTAINER_ID" -f
