#!/bin/bash
set -ex

packer init .
export HCP_PACKER_BUILD_FINGERPRINT=v0.2.0-$(date +%F_%H-%M-%S)
packer build -force .

# Update HCP Packer Channel
par channels set-iteration azure-webserver dev --fingerprint $HCP_PACKER_BUILD_FINGERPRINT
