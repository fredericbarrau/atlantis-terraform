# Atlantis custom build

## Build

```console
$ build.sh
```

## Run 

On development environment:

```console

$ ngrok http 8080
$ source .env 
$ run.sh
```

Create an `.env` file like:

```bash
# $URL is the URL that Atlantis can be reached at
ATLANTIS_ATLANTIS_URL=<ngrok url for local testing>
# $USERNAME is the GitHub/GitLab/Bitbucket/AzureDevops username you generated the token for
ATLANTIS_GH_USER=<username>
# $TOKEN is the access token you created. If you don't want this to be passed in as an argument for security reasons you can specify it in a config file (see Configuration) or as an environment variable: ATLANTIS_GH_TOKEN or ATLANTIS_GITLAB_TOKEN or ATLANTIS_BITBUCKET_TOKEN or ATLANTIS_AZUREDEVOPS_TOKEN
ATLANTIS_GH_TOKEN=<github token>
# $SECRET is the random key you used for the webhook secret. If you don't want this to be passed in as an argument for security reasons you can specify it in a config file (see Configuration) or as an environment variable: ATLANTIS_GH_WEBHOOK_SECRET or ATLANTIS_GITLAB_WEBHOOK_SECRET
ATLANTIS_GH_WEBHOOK_SECRET=<webhook secret>
# $REPO_ALLOWLIST is which repos Atlantis can run on, ex. github.com/runatlantis/* or github.enterprise.corp.com/*. See Repo Allowlist for more details.
ATLANTIS_REPO_ALLOWLIST=github.com/AODocs-Dev/*
# INFRACOST_API_TOKEN
INFRACOST_API_TOKEN=<infracost token>

export ATLANTIS_ATLANTIS_URL ATLANTIS_GH_USER ATLANTIS_GH_TOKEN ATLANTIS_GH_WEBHOOK_SECRET ATLANTIS_REPO_ALLOWLIST INFRACOST_API_TOKEN


```