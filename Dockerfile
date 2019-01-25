ARG BASE_TAG
FROM ubuntu:${BASE_TAG}

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    cmake \
    curl \
    g++ \
    make \
    python-dev \
    python-pip \
    python-setuptools \
    python3-dev \
    python3-pip \
    python3-setuptools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip2 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir numpy

RUN cd $(mktemp -d) \
    && curl -L https://github.com/opencv/opencv/archive/3.4.1.tar.gz | tar zxf - \
    && mkdir opencv-3.4.1/build \
    && cd opencv-3.4.1/build \
    && cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DWITH_OPENCL=OFF \
    -DWITH_CUDA=OFF \
    -DBUILD_WITH_DEBUG_INFO=OFF \
    -DBUILD_TESTS=OFF \
    -DBUILD_PERF_TESTS=OFF \
    -DBUILD_opencv_apps=OFF \
    -DBUILD_opencv_calib3d=OFF \
    -DBUILD_opencv_dnn=OFF \
    -DBUILD_opencv_features2d=OFF \
    -DBUILD_opencv_flann=OFF \
    -DBUILD_opencv_java_bindings_generator=OFF \
    -DBUILD_opencv_ml=OFF \
    -DBUILD_opencv_objdetect=OFF \
    -DBUILD_opencv_photo=OFF \
    -DBUILD_opencv_shape=OFF \
    -DBUILD_opencv_stitching=OFF \
    -DBUILD_opencv_superres=OFF \
    -DBUILD_opencv_video=OFF \
    -DBUILD_opencv_videoio=OFF \
    -DBUILD_opencv_videostab=OFF \
    && make -j $(nproc) \
    && make install \
    && rm -rf /tmp/*

RUN echo /usr/local/lib/ > /etc/ld.so.conf.d/local.conf \
    && ldconfig
