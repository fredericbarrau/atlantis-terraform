ARG TERRAGRUNT_VERSION=1.3.8 
ARG ATLANTIS_VERSION=0.22.3

FROM alpine/terragrunt:${TERRAGRUNT_VERSION}
FROM ghcr.io/runatlantis/atlantis:v${ATLANTIS_VERSION}-alpine

ARG INFRACOST_VERSION=0.10.17
ARG TERRAGRUNT_ATLANTIS_VERSION=1.16.0

# Copy terragrunt
COPY --from=0 /usr/local/bin/terragrunt /usr/local/bin/terragrunt

# Install infracost
# Install required packages and latest ${cli_version} version of Infracost
RUN apk --update --no-cache add ca-certificates openssl openssh-client curl git jq
RUN \
    curl -s -L "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz" | tar xz -C /tmp && \
    mv /tmp/infracost-linux-amd64 /usr/bin/infracost

# Setup terragrunt-atlantis-config
RUN \
    wget https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64.tar.gz &&\
    tar xf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64.tar.gz &&\
    mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64 terragrunt-atlantis-config &&\
    install terragrunt-atlantis-config /usr/local/bin 

# Git config
USER atlantis
RUN git config --global --add safe.directory '*'
