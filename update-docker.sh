#!/usr/bin/env bash

# Find all directories containing a docker-compose.yml
find . -name "docker-compose.yml" -printf '%h\n' | while read -r dir; do
    echo "-------------------------------------------"
    echo "Updating services in: $dir"
    echo "-------------------------------------------"

    pushd "$dir" > /dev/null

    # Pulling new images/updates and restart
    docker compose pull && docker compose up -d

    # Cleaning up old, unused images to save space
    docker image prune -f

    popd > /dev/null
done

echo "All stacks are up to date!"
