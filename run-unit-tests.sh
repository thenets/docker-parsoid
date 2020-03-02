#!/bin/bash

if [[ -z $1 ]]; then
    echo "[ERROR] Missing the image tag as arg!" >/dev/stderr
    echo "How to use: ./run-unit-tests.sh thenets/parsoid:0.11"
    exit 1
fi

set -x
DOCKER_IMAGE=$1

TEMP_DIR=$(mktemp -d)

docker run -it --rm \
    -w "/var/lib/parsoid" \
    -v ${TEMP_DIR}/npm_logs:/root/.npm/_logs/ \
    ${DOCKER_IMAGE} \
    npm test

set +x

echo ""
echo "[DONE] Log files at: ${TEMP_DIR}"

