FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV OLLAMA_HOST=0.0.0.0:11434
ENV OLLAMA_MODELS=/root/.ollama/models

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    ffmpeg \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN mkdir -p /root/.ollama/models

RUN (ollama serve > /tmp/ollama-build.log 2>&1 &) \
    && sleep 8 \
    && ollama pull qwen3-vl:8b \
    && ollama list \
    && pkill ollama || true

WORKDIR /workspace

CMD ["bash", "-lc", "ollama serve"]
