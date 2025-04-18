#!/bin/bash

echo "Stopping containers..."
docker compose down

echo "Starting containers with build..."
export BUILDKIT_PROGRESS=plain
docker compose up --force-recreate --build

echo "Script finished."
