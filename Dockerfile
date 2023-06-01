# syntax=docker/dockerfile:1.3-labs
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y \
  unzip curl openjdk-17-jre

WORKDIR /app

RUN curl -sSLo formatter.jar https://github.com/google/google-java-format/releases/download/v1.17.0/google-java-format-1.17.0-all-deps.jar
RUN curl -fsSL https://dprint.dev/install.sh | sh

# Quote heredoc so it doesn't eat quotes https://github.com/moby/buildkit/issues/2439
COPY <<"EOF" /dprint.json
{
  "typescript": {
  },
  "json": {
  },
  "markdown": {
  },
  "toml": {
  },
  "dockerfile": {
  },
  "exec": {
    "associations": "**/*.{java}",
    "java": "java -jar formatter.jar {{file_path}}"
    "java.associations": "**/*.java"
  },
  "includes": ["**/*.{ts,tsx,java,js,jsx,cjs,mjs,json,md,toml,dockerfile}"],
  "excludes": [
    "**/node_modules",
    "**/*-lock.json"
  ],
  "plugins": [
    "https://plugins.dprint.dev/typescript-0.84.4.wasm",
    "https://plugins.dprint.dev/json-0.17.2.wasm",
    "https://plugins.dprint.dev/markdown-0.15.2.wasm",
    "https://plugins.dprint.dev/toml-0.5.4.wasm",
    "https://plugins.dprint.dev/dockerfile-0.3.0.wasm",
    "https://plugins.dprint.dev/exec-0.3.5.json@d687dda57be0fe9a0088ccdaefa5147649ff24127d8b3ea227536c68ee7abeab"
  ]
}
EOF

ENTRYPOINT ["/root/.dprint/bin/dprint"]

LABEL org.opencontainers.image.source=https://github.com/zachauten/dprint-docker

