ARG BUILD_FROM=node:20-alpine
FROM ${BUILD_FROM}

RUN apk add --no-cache git bash docker-cli jq curl \
 && npm install -g @anthropic-ai/claude-code

COPY run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /share/nanoclaw
CMD ["/run.sh"]
