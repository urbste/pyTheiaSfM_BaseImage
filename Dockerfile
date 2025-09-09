FROM quay.io/pypa/manylinux_2_28_x86_64
 
RUN yum install -y wget atlas blas-devel lapack-devel

RUN mkdir -p /home/libs
ENV GFLAGS_VERSION=2.2.2
ENV CERES_VERSION=2.1.0

RUN cd /home/libs && \
    git clone https://gitlab.com/libeigen/eigen && \
    cd eigen && git checkout 3.4.0 && \
    mkdir build && cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Release && \
    make -j install && \
    cd /home/libs && \ 
    rm -rf eigen


RUN cd /home/libs && \
    wget https://github.com/gflags/gflags/archive/refs/tags/v${GFLAGS_VERSION}.tar.gz && \
    tar xzf v${GFLAGS_VERSION}.tar.gz && \
    cd gflags-${GFLAGS_VERSION} && \ 
    mkdir build && \ 
    cd build && \
    cmake ../ -DCMAKE_CXX_FLAGS='-fPIC' -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_CMP0075=NEW || \
    cmake ../ -DCMAKE_CXX_FLAGS='-fPIC' -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && \ 
    make -j install && \ 
    cd /home/libs && \ 
    rm -rf gflags-${GFLAGS_VERSION} && \
    rm -rf v${GFLAGS_VERSION}.tar.gz

RUN cd /home/libs && \
    git clone https://github.com/google/glog.git && \
    cd glog && mkdir build && cd build && \
    cmake ../ -DCMAKE_CXX_FLAGS='-fPIC' -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release && \ 
    make -j install && \ 
    cd /home/libs && \ 
    rm -rf glog

# Build Ceres
RUN cd /home/libs && \
    git clone https://github.com/ceres-solver/ceres-solver && \
    cd ceres-solver && \ 
    git checkout ${CERES_VERSION} && \ 
    mkdir -p build && \ 
    cd build && \
    cmake  ../ -DBUILD_DOCUMENTATION=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DEIGENSPARSE=ON -DSUITESPARSE=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release && \
    make -j install && \
    cd /home/libs && \ 
    rm -rf ceres-solver
