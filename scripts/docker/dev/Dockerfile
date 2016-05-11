FROM debian:jessie

WORKDIR /opt/code

RUN apt-get update && \
    apt-get install -y \
        curl \
        file \
        build-essential \
        && \
    apt-get autoremove && \
    apt-get clean

# Install rust
RUN curl -o rustup-install.sh https://sh.rustup.rs -sSf && \
    chmod a+x rustup-install.sh && \
    ./rustup-install.sh -y && \
    rm rustup-install.sh

RUN $HOME/.cargo/bin/rustup toolchain install stable && \
    $HOME/.cargo/bin/rustup target add x86_64-unknown-linux-musl
