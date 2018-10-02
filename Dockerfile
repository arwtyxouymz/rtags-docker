FROM ubuntu:16.04

LABEL maintainer "Ryutaro Matsumoto <taross0524.ss@gmail.com>"

# Install LLVM
RUN apt update && apt install -y --no-install-recommends \
    git \
    wget \
    build-essential \
    software-properties-common \
    cmake \
    # Add llvm keys
    && /bin/bash -c 'echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" > /etc/apt/sources.list.d/llvm.list' \
    && /bin/bash -c 'echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" > /etc/apt/sources.list.d/llvm.list' \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt update && apt install -y \
    libllvm6.0 \
    llvm-6.0 \
    llvm-6.0-dev \
    llvm-6.0-runtime \
    clang-6.0 \
    clang-tools-6.0 \
    libclang-common-6.0-dev \
    libclang-6.0-dev \
    libclang1-6.0 \
    clang-format-6.0 \
    python-clang-6.0 \
    lldb-6.0 \
    lld-6.0 \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/lib/llvm-6.0/bin:$PATH

# Install rtags
RUN git clone --recursive https://github.com/Andersbakken/rtags.git && cd rtags \
    && mkdir build && cd build \
    && cmake .. -DSKIP_CTEST=True -DLIBCLANG_LLVM_CONFIG_EXECUTABLE=/usr/lib/llvm-6.0/bin/llvm-config \
    && make -j4 \
    && make install \
    && cd / && rm -rf rtags


