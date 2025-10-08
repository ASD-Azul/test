ARG REGISTRY="docker.io/library"
ARG BUILD_IMAGE='python'
ARG BUILD_TAG='3.12-bookworm'
ARG BASE_IMAGE='nginxinc/nginx-unprivileged'
ARG BASE_TAG='stable-alpine'

FROM $REGISTRY/$BUILD_IMAGE:$BUILD_TAG AS builder
# copy all files not in .dockerignore
COPY ./ /tmp/src
# build sdist
WORKDIR /tmp/src
# install sdist
RUN pip install \
    -r ./requirements.txt
RUN mkdocs build

FROM $REGISTRY/$BASE_IMAGE:$BASE_TAG
COPY --from=builder /tmp/src/site/ /usr/share/nginx/html/dist

EXPOSE 8000
