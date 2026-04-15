ARG BUILD_FROM=ghcr.io/home-assistant/base:latest
FROM ${BUILD_FROM}

RUN apk add --no-cache \
      git bash docker-cli docker-cli-compose jq curl ttyd \
      nodejs npm \
      python3 make g++ \
 && npm install -g @anthropic-ai/claude-code

COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /share/nanoclaw
CMD ["/run.sh"]
