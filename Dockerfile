FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update && apt-get install -y --no-install-recommends \
        nano \
        vim \
        build-essential \
        cmake \
        git \
        wget \
        curl \
        libatlas-base-dev \
        liblas-c3 \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        libopenblas-dev \
        protobuf-compiler \
        python \
        python-dev \
        python-pip \
        python-setuptools 
#    rm -rf /var/lib/apt/lists/*

#RUN ln -sf /usr/bin/python3 /usr/bin/python & \
#    ln -sf /usr/bin/pip3 /usr/bin/pip

#RUN 
ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT

#RUN apt-get update && apt-get purge -y python-pip && \
#    wget https://bootstrap.pypa.io/get-pip.py && \
#    python ./get-pip.py && rm -rf ./get-pip.py && \
#    apt-get -y install python-pip && \
#    rm -rf /var/lib/apt/lists/*
#WORKDIR /workspace
RUN git clone --recursive https://github.com/lzyang2000/R-C3D.git

#RUN cd py-faster-rcnn/caffe-fast-rcnn/build && cmake -DUSE_CUDNN=0  .. && make -j"$(nproc)"

#RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
RUN pip install wheel numpy==1.11.1
RUN pip install opencv-python  opencv-contrib-python joblib liblas pypng

WORKDIR /usr/lib/x86_64-linux-gnu
RUN ln -s libhdf5_serial.so.8.0.2 libhdf5.so && ln -s libhdf5_serial_hl.so.8.0.2 libhdf5_hl.so

WORKDIR /opt/caffe/R-C3D/caffe3d
RUN make -j8 && make pycaffe
ENV PYCAFFE_ROOT $CAFFE_ROOT
ENV PYTHONPATH $PYCAFFE_ROOT/R-C3D/caffe3d/python
ENV PATH $CADFFE_ROOT/R-C3D/caffe3d/build/tools:$PYCAFFE_ROOT:$PATH
RUN pip install Cython==0.19.2 
RUN pip install ez_setup
RUN pip install scipy==1.1.0 scikit-image==0.9.3 matplotlib==2.2.4 ipython==3.0.0 h5py leveldb networkx==1.8.1 nose==1.3.0 pandas==0.12.0 python-dateutil==1.4 protobuf python-gflags==2.0 pyyaml==3.10 Pillow==2.3.0   
RUN pip install easydict

WORKDIR /opt/caffe/R-C3D/lib
RUN make
ENV PYTHONPATH $PYTHONPATH:/opt/caffe/R-C3D/lib
ENV CAFFE_ROOT=/opt/caffe/R-C3D/caffe3d
