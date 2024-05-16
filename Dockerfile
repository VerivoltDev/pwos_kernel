FROM amd64/ubuntu:20.04

RUN apt-get update && \
    apt-get -y install \
        bc \
        bison \
        build-essential \
        kmod \
        flex \
        libncurses-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libssl-dev \
        sudo


# Create duser user with sudo privileges
RUN useradd -ms /bin/bash -U duser && \
    usermod -aG sudo duser

# New added for disable sudo password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Set as default user
USER duser
WORKDIR /home/duser

# RUN export LANGUAGE=en_US.UTF-8
# RUN export LANG=en_US.UTF-8
# RUN export LC_ALL=en_US.UTF-8
# RUN export LC_CTYPE=en_US.UTF-8

CMD ["/bin/bash"]

# . /opt/vv/phytec/SDK-Yocto-Ampliphy-AM64x-PD23.2.0/environment-setup-aarch64-phytec-linux
