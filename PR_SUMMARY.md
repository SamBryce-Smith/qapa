# Pull Request: Add Docker support with conda-lock for reproducible builds

## Summary

This PR adds comprehensive Docker support to qapa with reproducible builds using conda-lock, along with automated CI/CD for building and publishing container images to GitHub Container Registry.

## Key Features

### 🐳 Docker Support
- **Multi-stage Dockerfile** using micromamba for efficient, reproducible builds
- **conda-lock integration** ensures exact dependency versions across all builds
- **Optimized image size** with multi-stage builds and cleanup steps
- **Non-root user** for improved security
- **Complete test suite** included in the container for validation

### 🔄 Reproducible Builds
- **`environment-lock.yml`**: Conda environment file optimized for lock generation
- **`conda-lock.yml`**: Generated lock file with pinned dependency versions (committed to repo)
- **`generate-lockfile.sh`**: Helper script for local lock file generation
- **Platform-specific**: Locked for linux-64 platform (standard for Docker/CI)

### 🚀 GitHub Actions CI/CD
- **Automated workflow** (`.github/workflows/docker-publish.yml`) that:
  - Generates conda-lock file from environment-lock.yml
  - Builds Docker image with locked dependencies
  - Runs comprehensive tests (Python + R test suites)
  - Publishes to GitHub Container Registry
  - Commits lock file back to repository (on manual runs)

### 🧪 Comprehensive Testing
- Basic functionality tests (qapa --version, --help, subcommands)
- Python, R, and bedtools availability verification
- **Full Python test suite** execution (`tests/run_py_tests.sh`)
- **Full R test suite** execution (`tests/run_R_tests.R`)
- All tests must pass before image publication

### 📚 Documentation
- **`DOCKER.md`**: Complete Docker usage guide
  - Building images locally
  - Running containers
  - Working with data volumes
  - Troubleshooting
- **Updated `README.md`**: Added Docker installation section
- **Inline documentation**: Comments throughout configuration files

## Workflow Triggers

The Docker build workflow runs on:
- **Release published**: Automatically builds and publishes when creating a GitHub release
- **Manual workflow dispatch**: Can be triggered manually from GitHub Actions tab

The previous `app-conda.yml` workflow has been disabled to avoid conflicts.

## Usage

### Pulling from Registry (after first release)

```bash
# Pull latest
docker pull ghcr.io/sambryce-smith/qapa:latest

# Run qapa
docker run --rm ghcr.io/sambryce-smith/qapa:latest --help

# Mount data directory
docker run --rm -v $(pwd)/data:/data ghcr.io/sambryce-smith/qapa:latest build --help
```

### Building Locally

```bash
# Generate lock file
./generate-lockfile.sh

# Build image
docker build -t qapa:local .

# Test
docker run --rm qapa:local --help
```

## Files Changed

### Added
- `.github/workflows/docker-publish.yml` - CI/CD workflow for Docker builds
- `Dockerfile` - Multi-stage Docker build configuration
- `environment-lock.yml` - Conda environment for lock generation
- `DOCKER.md` - Comprehensive Docker documentation
- `.dockerignore` - Docker build context optimization
- `generate-lockfile.sh` - Lock file generation helper script

### Modified
- `README.md` - Added Docker installation section
- `.github/workflows/app-conda.yml` - Disabled (renamed to .disabled)

### Generated (by CI)
- `conda-lock.yml` - Will be generated and committed by workflow

## Testing

All changes have been tested through multiple CI runs:
- ✅ Lock file generation successful
- ✅ Docker image builds successfully
- ✅ All tests (Python + R) pass in container
- ✅ qapa command works correctly in container
- ✅ All dependencies available (Python, R, bedtools, etc.)

## Benefits

1. **Reproducibility**: Exact dependency versions locked across all builds
2. **Portability**: Run qapa anywhere Docker is available
3. **Isolation**: No conflicts with local environments
4. **Distribution**: Easy sharing via container registry
5. **CI/CD**: Automated testing and publishing on releases
6. **Quality Control**: Comprehensive testing before publication

## Next Steps

After merging:
1. Create a GitHub release (e.g., v1.4.1)
2. Workflow will automatically build and publish the Docker image
3. Image will be available at `ghcr.io/sambryce-smith/qapa:v1.4.1`

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
