#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Missing docker image argument. Usage: build.sh <docker-image-name-with-tag>."
    exit 1;
fi

docker_image=$1

docker build -t $docker_image .
