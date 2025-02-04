# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    autoconf \
    automake \
    bison \
    flex \
    re2c \
    gdb \
    libtool \
    make \
    pkgconf \
    valgrind \
    git \
    nano \
    curl \
    wget \
    libxml2-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/php

# Build PHP debug version
RUN git clone https://github.com/php/php-src.git && \
    cd php-src && \
    git checkout PHP-8.4.4 && \
    ./buildconf --force && \
    ./configure --enable-debug \
        --prefix=/root/php-bin/DEBUG \
        --with-config-file-path=/root/php-bin/DEBUG/etc && \
    make -j4 && \
    make install && \
    cd .. && \
    mkdir -p /root/php-bin/DEBUG/etc

# Copy php.ini
COPY src/php.ini /root/php-bin/DEBUG/etc/

# Add PHP debug to PATH
RUN echo 'export PATH=/root/php-bin/DEBUG/bin:$PATH' >> /root/.bashrc

# Source .bashrc on container start
RUN echo 'source /root/.bashrc' >> /root/.profile

# Keep container running
CMD ["tail", "-f", "/dev/null"]