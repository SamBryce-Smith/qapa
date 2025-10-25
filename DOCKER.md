# Docker Usage for QAPA

This document describes how to build and use the QAPA Docker image.

## Building the Docker Image

### Prerequisites

The Docker image uses conda-lock for reproducible builds. Before building, you need to generate the lock file.

### Step 1: Generate the Conda Lock File

**Option A: Using the provided script (requires conda-lock)**

```bash
# Install conda-lock if not already installed
pip install conda-lock

# Generate the lock file
./generate-lockfile.sh
```

**Option B: Using Docker (if conda-lock is not available locally)**

This will be handled automatically by the GitHub Actions workflow.

### Step 2: Build the Docker Image

```bash
docker build -t qapa:latest .
```

## Using the Docker Image

### Basic Usage

The container uses `qapa` as the entrypoint. You can run any qapa command by passing it as arguments:

```bash
# Show help
docker run --rm qapa:latest --help

# Show version
docker run --rm qapa:latest --version

# Run qapa build command
docker run --rm -v $(pwd)/data:/data qapa:latest build [options]
```

### Working with Data

Mount your data directory to `/data` in the container:

```bash
docker run --rm \
  -v /path/to/your/data:/data \
  qapa:latest build --db ensembl ...
```

### Running a Complete Workflow

Example of running the complete qapa workflow:

```bash
# 1. Build the 3' UTR library
docker run --rm \
  -v $(pwd)/data:/data \
  qapa:latest build \
  --db ensembl \
  -g gencode.v38.annotation.gtf \
  -o output/qapa_3utrs.bed

# 2. Extract FASTA sequences
docker run --rm \
  -v $(pwd)/data:/data \
  qapa:latest fasta \
  -f genome.fa \
  output/qapa_3utrs.bed output/qapa_3utrs.fa

# 3. Quantify APA usage
docker run --rm \
  -v $(pwd)/data:/data \
  qapa:latest quant \
  --db output/qapa_3utrs.bed \
  quant_results.txt \
  output/pau_results.txt
```

## GitHub Container Registry

Once published, you can pull the image from GitHub Container Registry:

```bash
# Pull the latest image
docker pull ghcr.io/morrislab/qapa:latest

# Pull a specific version
docker pull ghcr.io/morrislab/qapa:v1.4.0

# Use in your workflow
docker run --rm ghcr.io/morrislab/qapa:latest --help
```

## Development

### Updating Dependencies

If you update `environment.yml`, regenerate the lock file:

```bash
./generate-lockfile.sh
```

Then rebuild the Docker image.

### Local Testing

```bash
# Build the image
docker build -t qapa:dev .

# Test basic functionality
docker run --rm qapa:dev --version
docker run --rm qapa:dev --help

# Run with test data
docker run --rm -v $(pwd)/examples:/data qapa:dev build --help
```

## Troubleshooting

### Lock File Issues

If you encounter issues with the lock file:

1. Ensure you have the latest version of conda-lock: `pip install -U conda-lock`
2. Delete the existing `conda-lock.yml` file
3. Regenerate: `./generate-lockfile.sh`

### Container Permissions

If you encounter permission issues with mounted volumes:

```bash
# Run as your user ID
docker run --rm --user $(id -u):$(id -g) \
  -v $(pwd)/data:/data \
  qapa:latest build ...
```

## GitHub Actions

The repository includes a GitHub Actions workflow that automatically:

1. Generates the conda-lock file
2. Builds the Docker image
3. Publishes to GitHub Container Registry on releases

See `.github/workflows/docker-publish.yml` for details.
