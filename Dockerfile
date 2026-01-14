FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:neovim-ppa/stable && \
    apt-get update && \
    apt-get install -y neovim git curl unzip && \
    apt-get clean

# Set up user (optional, for non-root usage)
RUN useradd -ms /bin/bash nvimuser
USER nvimuser
WORKDIR /home/nvimuser

# Copy everything from the current directory except files in .dockerignore
COPY --chown=nvimuser:nvimuser . /home/nvimuser/.config/nvim/

# Set default command
CMD ["nvim"]
