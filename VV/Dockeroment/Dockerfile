FROM amd64/ubuntu:20.04

ARG DUID
ARG DGID
ARG DUSR
ARG TZ

ARG VV_DIR_DOWN=${PWD}/VV/DOWN
ARG PHYTEC_SDK_URL=https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy
ARG PHYTEC_SDK_FILE=phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh
ARG PHYTEC_SDK_CHECKSUM=ed14ca396caa739287ff84d4868b5f77377feaa2

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        bc \
        bison \
        build-essential \
        ca-certificates \
        kmod \
        file \
        flex \
        git \
        inetutils-ping \
        libncurses-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libssl-dev \
        locales \
        python \
        rsync \
        ssh \
        sudo \
        tzdata \
        wget

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
RUN dpkg-reconfigure --frontend=noninteractive locales

# Clear root psw
RUN passwd -d root

# Create user
RUN groupadd -g ${DGID} ${DUSR} && \
    useradd -u ${DUID} -g ${DUSR} -m ${DUSR}

# DUSR with sudo privileges
RUN usermod -aG sudo ${DUSR}

# Disable sudo password
RUN echo 'ALL ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Set as default user
USER ${DUSR}

# To speed up The Dockerbuild, you can pre download the SDK from:
#     https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy/phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh
# And save it on this dir inside the repo:
#     VV/DOWN/
COPY ${PWD}/VV /tmp/VV

# Install Phytec SDK
RUN sudo mkdir -p /tmp/VV/DOWN && \
    cd /tmp/VV/DOWN && \
    sudo wget -c ${PHYTEC_SDK_URL}/${PHYTEC_SDK_FILE} && \
    echo "${PHYTEC_SDK_CHECKSUM}  /tmp/VV/DOWN/${PHYTEC_SDK_FILE}" | shasum -c && \
    sudo chmod a+x /tmp/VV/DOWN/${PHYTEC_SDK_FILE} && \
    mkdir ~/SDK_PHYTEC && \
    /tmp/VV/DOWN/${PHYTEC_SDK_FILE} -y -d ~/SDK_PHYTEC && \
    . ~/SDK_PHYTEC/environment-setup-aarch64-phytec-linux
    
RUN sudo rm -rf /tmp/VV

RUN sudo ln -s ~/SDK_PHYTEC/sysroots/aarch64-phytec-linux/lib/ld-linux-aarch64.so.1 /lib/ld-linux-aarch64.so.1

WORKDIR ${PWD}

CMD ["/bin/bash"]
