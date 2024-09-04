#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/init_sdk.bash

: "${WORKDIR:?err}"

VV_DIR_DOWN="${WORKDIR}/VV/DOWN"
VV_DIR_LOGS="${WORKDIR}/VV/LOGS"

PHYTEC_SDK_DIR="${WORKDIR}/SDK_PHYTEC"
PHYTEC_SDK_URL=https://download.phytec.de/Software/Linux/BSP-Yocto-AM64x/BSP-Yocto-Ampliphy-AM64x-PD23.2.1/sdk/ampliphy
PHYTEC_SDK_FILE=phytec-ampliphy-glibc-x86_64-phytec-headless-image-aarch64-toolchain-BSP-Yocto-Ampliphy-AM64x-PD23.2.1.sh
PHYTEC_SDK_CHECKSUM=ed14ca396caa739287ff84d4868b5f77377feaa2

LOGFILE_FILENAME=$(basename "$0")_$(date +"%y%m%d.%H%M").log
SCRIPT_LOGFILE=${VV_DIR_LOGS}/${LOGFILE_FILENAME}

function exitError {
    EXITMSG="${1:-ERROR}"
    echo "" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "####    ERROR    ####" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "" &>>"${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${FUNCNAME[1]}[${BASH_LINENO[0]}]" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${EXITMSG}" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "See ${SCRIPT_LOGFILE} for more details" || exit $LINENO
    # [[ $(type -t exitScript) == function ]] && exitScript || exit $LINENO
    exit $LINENO
}

mkdir -p "${VV_DIR_DOWN}" || exit $LINENO
mkdir -p "${VV_DIR_LOGS}" || exit $LINENO
touch "${SCRIPT_LOGFILE}" || exit $LINENO
printf "\n%s\n" "${SCRIPT_LOGFILE}" || exit $LINENO

echo "${WORKDIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

## SDK ###

if [[ -f ${VV_DIR_DOWN}/${PHYTEC_SDK_FILE} ]] && echo "${PHYTEC_SDK_CHECKSUM}  ${VV_DIR_DOWN}/${PHYTEC_SDK_FILE}" | shasum -c
then
    echo ">>> Skip download Phytec SDK, file found: ${PHYTEC_SDK_FILE}" |& tee -a "${SCRIPT_LOGFILE}"
else
    rm -vf "${VV_DIR_DOWN}"/${PHYTEC_SDK_FILE} &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    echo ">>> Downloading Phytec SDK" |& tee -a "${SCRIPT_LOGFILE}"
    wget ${PHYTEC_SDK_URL}/${PHYTEC_SDK_FILE} -P "${VV_DIR_DOWN}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
fi

if [[ -d ${PHYTEC_SDK_DIR} ]]
then
    echo ">>> Removing Phytec SDK Dir" |& tee -a "${SCRIPT_LOGFILE}"
    rm -rf "${PHYTEC_SDK_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
fi

if [[ -f ${VV_DIR_DOWN}/${PHYTEC_SDK_FILE} ]]
then
    # echo ">>> Check SDK file integrity" |& tee -a "${SCRIPT_LOGFILE}" |& tee -a "${SCRIPT_LOGFILE}"
    # echo "${PHYTEC_SDK_CHECKSUM}  ${VV_DIR_DOWN}/${PHYTEC_SDK_FILE}" | shasum -c &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    echo ">>> Installing Phytec SDK" |& tee -a "${SCRIPT_LOGFILE}"
    mkdir -vp "${PHYTEC_SDK_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    chmod -v a+x "${VV_DIR_DOWN}"/${PHYTEC_SDK_FILE} &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    "${VV_DIR_DOWN}"/${PHYTEC_SDK_FILE} -y -d "${PHYTEC_SDK_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    printf ">>> SDK has been successfully set up\n" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
fi
