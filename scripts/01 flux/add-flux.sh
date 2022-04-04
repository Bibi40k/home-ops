#!/bin/bash

if [ ! -f ./vars ]; then
    cp ${BASH_SOURCE%/*}/vars.sample ${BASH_SOURCE%/*}/vars
else
    source ${BASH_SOURCE%/*}/vars
fi
source ${BASH_SOURCE%/*}/pre.sh

REPO_NAME="home-ops"
REPO_BRANCH="main"
REPO_CLUSTER_PATH="k8s/clusters/cluster-0"

bootstrap_new_repo () {
    # This command creates the Repo on Git if not exist
    # Then install flux-system into repo
    flux bootstrap github \
        --owner=${GITHUB_USER} \
        --repository=${REPO_NAME} \
        --branch=${REPO_BRANCH} \
        --path=${REPO_CLUSTER_PATH} \
        --personal
    
    unset GITHUB_USER
    unset GITHUB_TOKEN

    # ERRORS:
    # ◎ waiting for Kustomization "flux-system/flux-system" to be reconciled
    # ✗ context deadline exceeded
    # ► confirming components are healthy
    # ✗ helm-controller: deployment not ready
    # ✗ kustomize-controller: deployment not ready
    # ✗ notification-controller: deployment not ready
    # ✗ source-controller: deployment not ready
    # ✗ bootstrap failed with 2 health check failure(s)
}

bootstrap_existing_repo () {
    # Run bootstrap for an existing repository
    flux bootstrap github \
        --owner=${GITHUB_USER} \
        --repository=${REPO_NAME} \
        --branch=${REPO_BRANCH} \
        --path=${REPO_CLUSTER_PATH} \
        --private=true \
        --personal=true \
        --reconcile=true \
        --sync-timeout=10m
    
    unset GITHUB_USER
    unset GITHUB_TOKEN
}

add_app_podinfo () {
    # Add podinfo repository to Flux
    flux create source git podinfo \
        --url=https://github.com/stefanprodan/podinfo \
        --branch=master \
        --interval=30s \
        --export > ./podinfo-source.yaml
    
    # Commit to Git
    git add -A && git commit -m "Add podinfo GitRepository"
    git push

    # Deploy podinfo application
    flux create kustomization podinfo \
        --target-namespace=default \
        --source=podinfo \
        --path="./kustomize" \
        --prune=true \
        --interval=5m \
        --export > ./podinfo-kustomization.yaml
    
    # Commit to Git
    git add -A && git commit -m "Add podinfo Kustomization"
    git push

    # Sync repo
    git pull
}

##############################################################################
###                             DISPLAY OPTIONS                            ###
##############################################################################
echo ""
echo "### OPTIONS #####################################################################"
echo "./add-flux.sh bootstrap_new_repo      - Create new repo and install Flux onto cluster"
echo "./add-flux.sh bootstrap_existing_repo - Create new repo and install Flux onto cluster"
echo "./add-flux.sh add_app_podinfo         - Real example to deploy 'podinfo' app onto cluster"
echo "#################################################################################"
echo ""

"$@"