FROM quay.io/pypa/manylinux2014_x86_64
 
RUN yum install -y wget eigen3-devel atlas-static blas-devel lapack-devel

RUN mkdir -p /home/libs

RUN cd /home/libs && \
    wget https://github.com/gflags/gflags/archive/refs/tags/v2.2.2.tar.gz && \
    tar xzf v2.2.2.tar.gz && \
    cd gflags-2.2.2 && \ 
    mkdir build && \ 
    cd build && \
    cmake ../ -DCMAKE_CXX_FLAGS='-fPIC' -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release && \ 
    make -j install && \ 
    cd /home/libs && \ 
    rm -rf gflags-2.2.2 && \
    rm -rf v2.2.2.tar.gz

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
    git checkout 2.1.0 && \ 
    mkdir -p build && \ 
    cd build && \
    cmake  ../ -DBUILD_DOCUMENTATION=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DEIGENSPARSE=ON -DSUITESPARSE=OFF -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release && \
    make -j install && \
    cd /home/libs && \ 
    rm -rf ceres-solver
