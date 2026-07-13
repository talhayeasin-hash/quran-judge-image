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
    openssh-server \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ollama/models

RUN (ollama serve > /tmp/ollama-build.log 2>&1 &) \
    && sleep 10 \
    && ollama pull qwen3-vl:8b \
    && ollama list \
    && pkill ollama || true

RUN mkdir -p /var/run/sshd /root/.ssh && chmod 700 /root/.ssh && ssh-keygen -A \
    && sed -ri 's/^#?PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config \
    && sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 22
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

WORKDIR /workspace

CMD ["/usr/local/bin/start.sh"]
