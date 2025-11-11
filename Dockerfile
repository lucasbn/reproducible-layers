# Use a specific digest instead of tag for maximum reproducibility
FROM ubuntu:24.04

# Set reproducible environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Create directory with consistent permissions
RUN mkdir -p /app && chmod 755 /app

# Copy with explicit ownership and permissions
COPY --chown=root:root --chmod=644 test.txt /app/test.txt

# Set consistent working directory
WORKDIR /app