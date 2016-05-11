if [ -z "$REPOROOT" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    REPOROOT="$DIR/.."
fi

SCRIPTS="$REPOROOT/scripts"
