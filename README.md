# DonkeyOS

## Build

podman build -t ghcr.io/rishooty/donkeyos:latest .

## Deploy

rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/rishooty/donkeyos:latest

## Push Container

podman push --creds YOUR_USER:YOUR_PERSONAL_ACCESS_TOKEN donkeyos:latest ghcr.io/rishooty/donkeyos:latest
or
podman login ghcr.io &&
podman push donkeyos:latest ghcr.io/rishooty/donkeyos:latest
