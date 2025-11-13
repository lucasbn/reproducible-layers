FROM ghcr.io/prefix-dev/pixi:0.59.0

# Set environment variables for reproducibility
ENV SOURCE_DATE_EPOCH=946684800
ENV TZ=UTC
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONHASHSEED=0

COPY --chown=root:root --chmod=644 pixi.toml pixi.toml
COPY --chown=root:root --chmod=644 pixi.lock pixi.lock

# Run pixi install and then fix all timestamps and sort order issues
RUN pixi install --locked \
    && find .pixi/ /root/.pixi/ /root/.cache/ -type f -exec touch -t 200001010000 {} + 2>/dev/null || true \
    && find .pixi/ /root/.pixi/ /root/.cache/ -type d -exec touch -t 200001010000 {} + 2>/dev/null || true \
    && find .pixi/ -name "*.pyc" -delete 2>/dev/null || true \
    && find /root/.pixi/ -name "*.pyc" -delete 2>/dev/null || true
