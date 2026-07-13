FROM ollama/ollama:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_MODELS=/root/.ollama/models

USER root

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    ffmpeg \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ollama/models

RUN (ollama serve > /tmp/ollama-build.log 2>&1 &) \
    && sleep 10 \
    && ollama pull qwen3-vl:8b \
    && ollama list \
    && pkill ollama || true

WORKDIR /workspace

CMD ["bash", "-lc", "ollama serve"]
