#!/bin/sh -e

docker build -t yocto-20-04 .

docker run \
    -v $PWD:$PWD \
    -w $PWD \
    -v /opt/vv/phytec/SDK-Yocto-Ampliphy-AM64x-PD23.2.0:/opt/vv/phytec/SDK-Yocto-Ampliphy-AM64x-PD23.2.0 \
    --network host \
    -e APT_HTTP_PROXY \
    -e PYDOJOBS \
    -e TERM \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    --privileged \
    --rm \
    -it yocto-20-04


    # -v /opt/vv/git/pwos_phytec_sdk:/opt/phytec_sdk \
# . /opt/vv/phytec/SDK-Yocto-Ampliphy-AM64x-PD23.2.1/environment-setup-aarch64-phytec-linux
