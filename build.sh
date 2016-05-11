#!/bin/sh
source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/scripts/_common.sh"

"$SCRIPTS/docker/enter.sh" /opt/code/scripts/run-build.sh
