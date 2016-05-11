#!/bin/sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../_common.sh"

"$SCRIPTS/docker/build.sh"

if [ -z "$1" ]; then
    docker run -it --rm -v "$REPOROOT:/opt/code" isix-build sh
else
    docker run -it --rm -v "$REPOROOT:/opt/code" isix-build "$@"
fi
