#!/usr/bin/env bash
#
# Generate terragrunt configuration
#

# TODO with a single atlantis instance, restricting 2 plan/apply in parallel

terragrunt-atlantis-config generate --output atlantis.yaml --autoplan --automerge --parallel \
  --num-executors 2
