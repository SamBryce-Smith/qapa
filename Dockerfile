# Multi-stage Dockerfile for qapa using conda-lock
# Based on conda-lock Docker best practices: https://conda.github.io/conda-lock/docker/

# Stage 1: Build environment with dependencies
FROM mambaorg/micromamba:1.5.10 AS build

# Set working directory
WORKDIR /tmp/build

# Copy conda-lock file
COPY conda-lock.yml /tmp/build/conda-lock.yml

# Create environment from lockfile using micromamba
# micromamba can directly install from conda-lock files
USER $MAMBA_USER
RUN micromamba create -n qapa --file /tmp/build/conda-lock.yml -y && \
    micromamba clean --all --yes

# Stage 2: Runtime image
FROM mambaorg/micromamba:1.5.10

# Copy the environment from build stage
COPY --from=build /opt/conda/envs/qapa /opt/conda/envs/qapa

# Set environment variables
ENV PATH="/opt/conda/envs/qapa/bin:${PATH}"
ENV CONDA_DEFAULT_ENV=qapa

# Copy qapa source code
WORKDIR /app
COPY . /app/

# Install qapa package
USER root
RUN /opt/conda/envs/qapa/bin/pip install --no-deps .

# Create a non-root user for running the application
RUN useradd -m -u 1000 qapa_user && \
    chown -R qapa_user:qapa_user /app

USER qapa_user
WORKDIR /data

# Set qapa as entrypoint
ENTRYPOINT ["/opt/conda/envs/qapa/bin/qapa"]
CMD ["--help"]

# Add labels
LABEL org.opencontainers.image.title="qapa" \
      org.opencontainers.image.description="RNA-seq Quantification of Alternative PolyAdenylation" \
      org.opencontainers.image.version="1.4.0" \
      org.opencontainers.image.source="https://github.com/morrislab/qapa" \
      org.opencontainers.image.licenses="GPL-3.0"
