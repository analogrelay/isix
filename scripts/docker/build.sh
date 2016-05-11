#!/bin/sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_common.sh"

docker build -t isix-build "$SCRIPTS/docker/dev"
