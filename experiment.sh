#!/bin/bash

build_and_inspect() {
    # Remove any existing builder to ensure clean state
    docker buildx rm mybuilder 2>/dev/null || true
    
    # Create a fresh builder with specific configuration
    docker buildx create --use --name mybuilder --driver docker-container --config /dev/null

    # Set multiple environment variables for reproducibility
    DOCKER_BUILDKIT=1 \
    SOURCE_DATE_EPOCH=0 \
    BUILDKIT_INLINE_CACHE=0 \
    BUILDKIT_PROGRESS=plain \
    docker buildx build \
        --no-cache \
        --pull \
        --load \
        --build-arg BUILDKIT_INLINE_CACHE=0 \
        --build-arg SOURCE_DATE_EPOCH=0 \
        --metadata-file=/tmp/build-metadata.json \
        --progress=plain \
        -t reprod:local \
        .
    
    echo "Build metadata:"
    cat /tmp/build-metadata.json 2>/dev/null || echo "No metadata file found"
    echo ""
    
    echo "Inspecting layers:"
    docker inspect docker.io/library/reprod:local --format '{{json .RootFS.Layers}}' | jq -r '.[]'

    # Clean up builder
    docker buildx rm mybuilder
}

# First run
echo "=== FIRST BUILD ==="
echo "Build time: $(date)"
echo "Docker version: $(docker --version)"
echo "Buildx version: $(docker buildx version)"
echo ""
build_and_inspect

echo ""
echo "=== WAITING ==="
sleep 2
echo ""

echo "=== SECOND BUILD ==="
echo "Build time: $(date)"
# Second run
build_and_inspect
