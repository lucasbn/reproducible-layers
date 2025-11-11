# Use a specific digest instead of tag for maximum reproducibility
FROM ubuntu:24.04

# Set reproducible environment variables
ENV SOURCE_DATE_EPOCH=0

# Create directory with consistent permissions
RUN mkdir -p /app && \
    chmod 644 /app && \
    chown root:root /app && \
    find /app -exec touch -h -d "@${SOURCE_DATE_EPOCH}" {} +

# Copy with explicit ownership and permissions
COPY --chown=root:root --chmod=644 test.txt test.txt