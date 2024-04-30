FROM ubuntu:jammy
ENV MJX_BUILD_BOOST=OFF
ENV MJX_BUILD_GRPC=OFF
WORKDIR /root
RUN apt-get update && \
    apt-get install -y build-essential \
    libboost-all-dev \
    cmake \
    python3.10 \
    python3.10-dev \
    python3-pip \
    git
RUN python3 -m pip install wheel
RUN git clone --recurse-submodules -b v1.62.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc
RUN cd grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF ../.. && \
    make -j 12 && \
    make install
RUN git clone -b tomohxx --recursive https://github.com/tomohxx/mjx.git
RUN cd mjx && python3 setup.py bdist_wheel
