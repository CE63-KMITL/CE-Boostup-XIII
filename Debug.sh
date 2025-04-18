#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
LOG_FILE="Debug.log"

if [ "$1" = "__LOGGING_ACTIVE__" ]; then
    shift

    docker compose down
    if [ $? -ne 0 ]; then
        exit 1
    fi

    export BUILDKIT_PROGRESS=plain

    docker compose up --force-recreate --build
    BUILD_EXIT_CODE=$?

    exit $BUILD_EXIT_CODE

else

    bash "${SCRIPT_PATH}" __LOGGING_ACTIVE__ "$@" | tee "$LOG_FILE"
    SCRIPT_EXIT_STATUS=${PIPESTATUS[0]}

    read -p "Press Enter to close this window..."

    exit $SCRIPT_EXIT_STATUS
fi