FROM python:3.6.13
LABEL maintainer="reeve0930 <reeve0930@gmail.com>"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    zsh \
    git \
    libgl1-mesa-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip

WORKDIR /home/user/work
ENV HOME=/home/user \
    ENTRYKIT_VERSION=0.4.0 \
    PATH=$PATH:/home/user/.poetry/bin

RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz && \
    mv entrykit /bin/entrykit && \
    chmod +x /bin/entrykit && \
    entrykit --symlink

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - && \
    poetry config virtualenvs.in-project true && \
    echo 'alias python="poetry run python"' >> $HOME/.zshrc

CMD ["prehook", "poetry install", "--", "/bin/zsh"]