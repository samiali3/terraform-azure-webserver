#!/bin/bash

#source ../env.sh

packer init .
HCP_PACKER_BUILD_FINGERPRINT=v0.2.0-$(date +%F_%H-%M-%S) packer build -force .
