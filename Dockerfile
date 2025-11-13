FROM ghcr.io/prefix-dev/pixi:0.59.0

ENV SOURCE_DATE_EPOCH=200001010000
ENV TZ=UTC
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY --chown=root:root --chmod=644 pixi.toml pixi.toml
COPY --chown=root:root --chmod=644 pixi.lock pixi.lock

RUN pixi install --locked \
        && find .pixi/ -type f -exec touch -t "$SOURCE_DATE_EPOCH" {} + \
        && find /root/ -type f -exec touch -t "$SOURCE_DATE_EPOCH" {} +