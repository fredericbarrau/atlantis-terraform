
FROM alpine/terragrunt:1.3.8
FROM ghcr.io/runatlantis/atlantis:v0.22.3-alpine

# Copy terragrunt
COPY --from=0 /usr/local/bin/terragrunt /usr/local/bin/terragrunt

# Install infracost
# Install required packages and latest ${cli_version} version of Infracost
RUN apk --update --no-cache add ca-certificates openssl openssh-client curl git jq
RUN \
    curl -s -L "https://github.com/infracost/infracost/releases/download/v0.10.17/infracost-linux-amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/infracost-linux-amd64 /usr/bin/infracost

# Git config
USER atlantis
RUN git config --global --add safe.directory '*'
