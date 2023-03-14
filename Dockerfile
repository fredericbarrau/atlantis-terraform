ARG TERRAGRUNT_VERSION=1.3.8
ARG ATLANTIS_VERSION=0.22.3
ARG INFRACOST_VERSION=0.10.17
ARG TERRAGRUNT_ATLANTIS_VERSION=1.16.0

FROM alpine/terragrunt:${TERRAGRUNT_VERSION}
FROM ghcr.io/runatlantis/atlantis:v${ATLANTIS_VERSION}-alpine

# ARGs used after FROM, so they must be re-declared
ARG INFRACOST_VERSION
ARG TERRAGRUNT_ATLANTIS_VERSION

# Copy terragrunt
COPY --from=0 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
# Make terragrunt runnable by all
RUN chmod 0755 /usr/local/bin/terragrunt

# Install infracost
# Install required packages and latest ${cli_version} version of Infracost
RUN apk --update --no-cache add ca-certificates openssl openssh-client curl git jq
RUN \
    curl -s -L "https://github.com/infracost/infracost/releases/download/v${INFRACOST_VERSION}/infracost-linux-amd64.tar.gz" | tar xz -C /tmp && \
    install /tmp/infracost-linux-amd64 /usr/bin/infracost

# Setup terragrunt-atlantis-config
RUN \
    wget https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64.tar.gz &&\
    tar xf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64.tar.gz &&\
    mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_VERSION}_linux_amd64 terragrunt-atlantis-config &&\
    install terragrunt-atlantis-config /usr/local/bin

# Install python3 for Gcloud installer
# Install jq for custom scripts
RUN apk add python3 jq

# Install gcloud as root
ENV CLOUDSDK_INSTALL_DIR /usr/local/gcloud
RUN curl -sSL https://sdk.cloud.google.com | bash
RUN ln -s /usr/local/gcloud/google-cloud-sdk/bin/gcloud /usr/local/bin/gcloud
RUN ln -s /usr/local/gcloud/google-cloud-sdk/bin/gsutil /usr/local/bin/gsutil

# Copy the utility scripts
COPY ./scripts /scripts
RUN chown -R atlantis:atlantis /scripts && chmod +x /scripts/*

# Copy the configuration files
COPY ./config /config
RUN chown -R atlantis:atlantis /config
RUN chmod -R u+rX,go-w /config

# Create the empty data directory
COPY ./data /data
RUN chown atlantis:atlantis /data
RUN chmod u+rwx,go-rwx /data

USER atlantis
# Configure git for sharing volume files
RUN git config --global --add safe.directory '*'

# Setup Gcloud SDK
RUN gcloud config set disable_usage_reporting false
# Set the env var for the configuration file
ENV ATLANTIS_CONFIG /config/server-settings.yaml
ENTRYPOINT [ "atlantis", "server" ]
