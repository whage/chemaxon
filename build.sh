#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Missing ECR repository name argument. Usage: build.sh <ecr-repository-name>."
    exit 1;
fi

ecr_repository=$1

docker build -t "${ecr_repository}:1.0.0" .
