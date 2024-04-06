ARG from
FROM ${from}

SHELL ["/bin/bash", "-ci"]

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon

RUN apt-get update && apt-get upgrade -y &&\
    apt-get install --no-install-recommends -y \
    git curl wget unzip tmux\
    net-tools vim nano lsb-release \ 
	build-essential gcc g++ cmake make \
	libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
	libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev \
    yasm libatlas-base-dev gfortran libpq-dev \
    libxine2-dev libglew-dev libtiff5-dev zlib1g-dev libavutil-dev libpostproc-dev \ 
    python3-dev python3-pip libx11-dev tzdata apt-utils mesa-utils gnupg2 \
    && rm -rf /var/lib/apt/lists/* && apt autoremove && apt clean

RUN apt-get update \
    && libpcl-dev libeigen3-dev \
    && apt-get install -q -y openssh-client \
    && apt-get install -q -y python3-opencv \
    && apt-get update -y || true && apt-get install -y \ 
	&& apt-get install -y --no-install-recommends libopencv-dev \
    && rm -rf /var/lib/apt/lists/* && apt autoremove && apt clean

RUN apt update && apt install -y libgl-dev && apt-get install -y python3-opengl libusb-1.0-0 python3-tk

RUN mkdir /workspace -p
WORKDIR /workspace

COPY ./requirements.txt /workspace/monogs/requirements.txt
RUN cd monogs && pip3 install -r requirements.txt
COPY ./submodules /workspace/monogs/submodules
RUN cd monogs/submodules && pip3 install ./simple-knn/ && pip3 install ./diff-gaussian-rasterization/


