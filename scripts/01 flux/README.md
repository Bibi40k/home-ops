<!-- https://fluxcd.io/docs/get-started/#install-the-flux-cli -->

# Install the Flux CLI
brew install fluxcd/tap/flux
flux -v

# Export Git credentials
GITHUB_USER="Bibi40k"
GITHUB_TOKEN=<your-token>
printenv | grep GITHUB