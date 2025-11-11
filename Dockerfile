FROM ghcr.io/prefix-dev/pixi:0.59.0

ENV SOURCE_DATE_EPOCH=0

COPY --chown=root:root --chmod=644 pixi.toml pixi.toml
COPY --chown=root:root --chmod=644 pixi.lock pixi.lock

RUN pixi install && find .pixi/ -type f -exec touch -t 200001010000 {} +