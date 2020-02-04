FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    pkg-config \
    python \
    python-dev \
    build-essential \
    texlive-xetex \
    git \
    rsync \
    software-properties-common \
    unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

RUN pip3 --no-cache-dir install \
    numpy \
    scipy \
    sympy \
    matplotlib \
    AstroML \
    healpy \
    quantities \
    ghostscript \
    texlive-core \
    pandas

# Install TensorFlow CPU version from central repo
#RUN pip3 --no-cache-dir install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0rc0-cp35-cp35m-linux_x86_64.whl

# Install Keras as blessed lightweight framework, sklearn for metrics, etc.
RUN pip3 install sklearn
# RUN pip3 install --upgrade git+https://github.com/fchollet/keras.git

EXPOSE 6006
CMD ["python3"]
