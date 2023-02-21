#!/usr/bin/env bash

_exitHandler() {
    docker stop $CONTAINER_ID
}

trap '_exitHandler' INT TERM QUIT

[[ -s .env ]] && source .env

# Get an OAUTH token from the authenticated user
# Will last for 1 hour
GOOGLE_OAUTH_ACCESS_TOKEN="$(gcloud auth print-access-token)"
CONTAINER_ID=$(docker run -d -p 8080:8080 \
    -v "$PWD/data":/data \
    -v "$PWD/config":/config \
    -e GOOGLE_OAUTH_ACCESS_TOKEN="$GOOGLE_OAUTH_ACCESS_TOKEN" \
    -e INFRACOST_API_KEY="$INFRACOST_API_TOKEN" \
    -e ATLANTIS_GH_TOKEN="$ATLANTIS_GH_TOKEN" \
    fredericbarrau/atlantis-custom server \
    --config=/config/server-settings.yaml \
    --atlantis-url="$ATLANTIS_URL" \
    --gh-user="$ATLANTIS_GH_USERNAME" \
    --gh-token="$ATLANTIS_GH_TOKEN" \
    --gh-webhook-secret="$ATLANTIS_GH_WEBHOOK_SECRET" \
    --repo-allowlist="$ATLANTIS_REPO_ALLOWLIST")
docker logs "$CONTAINER_ID" -f
