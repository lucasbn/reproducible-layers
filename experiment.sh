#!/bin/bash

build_and_inspect() {
    # Remove any existing builder to ensure clean state
    docker buildx rm mybuilder 2>/dev/null || true
    
    # Create a fresh builder with specific configuration
    docker buildx create --use --name mybuilder --driver docker-container --config /dev/null

    # Apply fixed timestamps to all files to ensure reproducibility
    find . -type f -exec touch -t 200001010000 {} +

    # Set multiple environment variables for reproducibility
    docker buildx build \
        --no-cache \
        --load \
        --progress=plain \
        -t reprod:local \
        . 2>/dev/null # Be VERY careful that the build isn't failing silently
    
    echo "Inspecting layers:"
    docker inspect docker.io/library/reprod:local --format '{{json .RootFS.Layers}}' | jq -r '.[]'

    # Clean up builder
    docker buildx rm mybuilder

    # Delete the image (make sure that we don't fail the build and show layers
    # being the same just because it's reading the same old image)
    docker rmi reprod:local
}

# First run
build_and_inspect

sleep 5
touch pixi.toml
touch pixi.lock

# Second run
build_and_inspect
