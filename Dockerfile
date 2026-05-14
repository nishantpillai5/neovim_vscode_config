FROM archlinux:base

RUN \
  pacman -Syu --noconfirm && \
  pacman -S --noconfirm \
    fd \
    gcc \
    fzf \
    git \
    make \
    curl \
    wget \
    bash \
    gzip \
    unzip \
    neovim \
    ripgrep \
    lazygit \
    tree-sitter-cli \
    python-pip \
    pkg-config \
    base-devel \
    go \
    npm \
    ruby \
    yarn \
    imagemagick \
    cargo \
    python3 \
    zsh \
    lua51 \
    luarocks

# RUN luarocks install luafilesystem && \
#     luarocks install luarocks-build-treesitter-parser && \
#     luarocks install tree-sitter-http && \
#     luarocks install nvim-nio && \
#     luarocks install mimetypes && \
#     luarocks install xml2lua && \
#     luarocks install fidget.nvim

RUN python -m venv /home/nvimuser/.virtualenvs/neovim
RUN /home/nvimuser/.virtualenvs/neovim/bin/python -m ensurepip
RUN /home/nvimuser/.virtualenvs/neovim/bin/python -m pip install -U pynvim

USER root
RUN useradd -ms /bin/bash nvimuser

# Pre-create all required runtime directories and set ownership
RUN mkdir -p /home/nvimuser/.local/share/nvim/lazy \
             /home/nvimuser/.local/share/nvim/lazy-rocks \
             /home/nvimuser/.local/state/nvim \
             /home/nvimuser/.cache && \
    chown -R nvimuser:nvimuser /home/nvimuser/.local /home/nvimuser/.cache

RUN mkdir -p /home/nvimuser/.luarocks && \
    echo "local_by_default = true" > /home/nvimuser/.luarocks/config-5.1.lua && \
    chown -R nvimuser:nvimuser /home/nvimuser/.luarocks

# Set up user
USER nvimuser
WORKDIR /home/nvimuser

# Set default command
CMD ["nvim"]
