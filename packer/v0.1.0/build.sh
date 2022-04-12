#!/bin/bash
set -ex

packer init .
export HCP_PACKER_BUILD_FINGERPRINT=v0.1.0-$(date +%F_%H-%M-%S)
packer build -force .

# Update HCP Packer Channel
par channels set-iteration azure-webserver production --fingerprint $HCP_PACKER_BUILD_FINGERPRINT

# In a real golden image pipeline, this would be set to "dev", and go through
# a testing procedure. Once validated, it could be promoted to "production"
#
# For the sake of my demo however, we call v0.1.0 Production
