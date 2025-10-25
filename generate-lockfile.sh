#!/usr/bin/env bash
#
# Generate conda-lock file for qapa
# This script should be run in an environment with conda-lock installed
#
# Usage: ./generate-lockfile.sh
#

set -euo pipefail

echo "Generating conda-lock file for qapa..."
echo "Platforms: linux-64"
echo ""

# Check if conda-lock is available
if ! command -v conda-lock &> /dev/null; then
    echo "Error: conda-lock is not installed"
    echo "Please install it with: pip install conda-lock"
    exit 1
fi

# Generate lock file for linux-64 (Docker/CI platform)
# Note: Using environment-lock.yml which excludes the local pip install
conda-lock lock \
    --file environment-lock.yml \
    --platform linux-64 \
    --lockfile conda-lock.yml

echo ""
echo "Lock file generated successfully: conda-lock.yml"
echo "You can now build the Docker image with: docker build -t qapa ."
