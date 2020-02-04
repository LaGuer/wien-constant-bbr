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
    apt-get clean && \
    rm get-pip.py && \
    rm -rf /var/lib/apt/lists/*
    

RUN pip3 --no-cache-dir install \
    numpy \
    scipy \
    sympy \
    matplotlib \
    AstroML \
    healpy \
    quantities \
    ghostscript \
    #texlive-core \
    pandas

# Install TensorFlow CPU version from central repo
#RUN pip3 --no-cache-dir install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.11.0rc0-cp35-cp35m-linux_x86_64.whl

# Install Keras as blessed lightweight framework, sklearn for metrics, etc.
#RUN pip3 install sklearn
# RUN pip3 install --upgrade git+https://github.com/fchollet/keras.git

#EXPOSE 6006
#CMD ["python3"]
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen 
    #locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV VIRTUAL_ENV /srv/venv
ENV PATH ${VIRTUAL_ENV}/bin:${PATH}

# Use bash as default shell, rather than sh
ENV SHELL /bin/bash

# Set up user
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

WORKDIR ${HOME}

RUN mkdir -p ${VIRTUAL_ENV} && chown ${NB_USER}:${NB_USER} ${VIRTUAL_ENV}

User jovyan
RUN echo $PYTHONHOME
RUN echo $PYTHONPATH
RUN echo $PATH
#RUN virtualenv ${VIRTUAL_ENV}
#ENV PYTHONHOME ${VIRTUAL_ENV}

# Install notebook extensions
#RUN pip install --no-cache-dir \
#    jupyter 
#    jupyter_contrib_nbextensions \
#    jupyterhub-legacy-py2-singleuser==0.7.2

RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable widgetsnbextension --py
RUN jupyter nbextension enable equation-numbering/main

# Install clawpack-v5.4.0:
#RUN pip2 install --src=$HOME/clawpack -e git+https://github.com/LaGuer/clawpack.git@v5.4.0#egg=clawpack-v5.4.0

# Add book's files
RUN git clone --depth=1 https://github.com/LaGuer/wien-constant-bbr

RUN pip install --no-cache-dir -r $HOME/wien-constant-bbr/requirements.txt

CMD jupyter notebook --ip='*'


