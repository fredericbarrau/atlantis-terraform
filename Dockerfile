FROM alpine/terragrunt:1.3.8
FROM ghcr.io/runatlantis/atlantis:v0.22.3-alpine

# Copy terragrunt
COPY --from=0 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
USER atlantis
RUN git config --global --add safe.directory '*'
