#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/build_lwb5p_modules.bash

: "${WORKDIR:?err}"

DATESTAMP=$(date +"%y%m%d.%H%M")
VV_DIR_LOGS="${WORKDIR}/VV/LOGS"
LOGFILE_FILENAME=$(basename "$0")_${DATESTAMP}.log
SCRIPT_LOGFILE=${VV_DIR_LOGS}/${LOGFILE_FILENAME}
LAIRD_BACKPORTS_DIR="${WORKDIR}/summit-backports-12.29.0.22"
# PHYTEC_SDK_DIR="${WORKDIR}"/SDK_PHYTEC
PHYTEC_SDK_DIR=~/SDK_PHYTEC

function exitError {
    EXITMSG="${1:-ERROR}"
    echo "" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "####    ERROR    ####" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "" &>> "${SCRIPT_LOGFILE}" || exit $LINENO
    tail "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "" &>> "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${FUNCNAME[1]}[${BASH_LINENO[0]}]" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${EXITMSG}" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "See ${SCRIPT_LOGFILE} for more details" || exit $LINENO
    # [[ $(type -t exitScript) == function ]] && exitScript || exit $LINENO
    echo ""
    exit $LINENO
}

mkdir -p "${VV_DIR_LOGS}" || exit $LINENO
touch "${SCRIPT_LOGFILE}" || exit $LINENO
printf "\n%s\n" "${SCRIPT_LOGFILE}" || exit $LINENO

echo "${WORKDIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

[[ -f "${VV_DIR_LOGS}"/VV_LAST_KERNEL_DIR ]] && \
    KERNEL_OUT_DIR=$(cat "${VV_DIR_LOGS}"/VV_LAST_KERNEL_DIR) || \
    exitError "Build Kernel first"

echo ">>> Setup environment" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
# shellcheck source=/dev/null
# . "${PHYTEC_SDK_DIR}"/environment-setup-aarch64-phytec-linux
# sudo ln -s "${PHYTEC_SDK_DIR}"/sysroots/aarch64-phytec-linux/lib/ld-linux-aarch64.so.1 /lib/ld-linux-aarch64.so.1 &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
export KLIB_BUILD=${WORKDIR}
export LD_LIBRARY_PATH=${PHYTEC_SDK_DIR}/sysroots/aarch64-phytec-linux/lib/
cd "${LAIRD_BACKPORTS_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
# sleep 5

echo ">>> Setup .config" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make defconfig-lwb_nbt &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Building Laird Backports" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make -j"$(nproc)" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Installing Modules" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make INSTALL_MOD_PATH="${KERNEL_OUT_DIR}" modules_install &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Kernel AND Laird backports has been successfully build!!" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
echo ">>> OUT files are located in:" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
printf ">>> ./xOUT that point to %s\n\n" "${KERNEL_OUT_DIR}" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO

## shellcheck source=/dev/null
# . ~/SDK_PHYTEC/environment-setup-aarch64-phytec-linux && \
# export KLIB_BUILD=${WORKDIR} && \
# export LD_LIBRARY_PATH=~/SDK_PHYTEC/sysroots/aarch64-phytec-linux/lib/ && \
# cd ${WORKDIR}/summit-backports-12.29.0.22 && \
# make defconfig-lwb_nbt && \
# make -j$(nproc) && \
# make INSTALL_MOD_PATH="$(cat ${WORKDIR}/VV/LOGS/VV_LAST_KERNEL_DIR)" modules_install
