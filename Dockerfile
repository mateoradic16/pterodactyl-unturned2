FROM ubuntu:latest

MAINTAINER Isaac A, <isaac@isaacs.site>

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture amd64 && \
    apt update && \
    apt upgrade -y && \
    apt install -y curl screen htop unzip lib32stdc++6 mono-runtime mono-reference-assemblies-2.0 libc6:amd64 libgl1-mesa-glx:amd64 libxcursor1:amd64 libxrandr2:amd64 libc6-dev-amd64 libgcc-4.8-dev:amd64 && \
    useradd -d /home/container -m container

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
