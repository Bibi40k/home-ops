#!/bin/bash

##############################################################################
###                           DEFINING VARIABLES                           ###
##############################################################################
GITHUB_USER="Bibi40k"

# Github Token
if [ -z ${GITHUB_TOKEN} ]; then
    read -s -p "Please enter Github Token: " response
    sed -i '' -e 's/GITHUB_TOKEN=.*/GITHUB_TOKEN='\"$response\"'/' ./vars
    echo ""
fi
GITHUB_TOKEN=${GITHUB_TOKEN:=${response}}

##############################################################################
###                              REQUIREMENTS                              ###
##############################################################################
APP_FLUX="/usr/local/bin/flux"
if [ ! -f "$APP_FLUX" ]; then
    read -p "Flux CLI does not exist [$APP_FLUX], do you want me to install it ? [Y/n] " response
    if [[ ! $response =~ ^([nN][oO]|[nN])$ ]]; then
        # https://fluxcd.io/docs/get-started/#install-the-flux-cli
        brew install fluxcd/tap/flux
        flux -v
    else
        echo "You chose not to install Flux CLI. We exit."
        exit 1
    fi
fi

# Check if Kubernetes cluster is ready for Flux
echo ""
flux check --pre
