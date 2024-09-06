#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/build_kernel.bash

: "${WORKDIR:?err}"

DATESTAMP=$(date +"%y%m%d.%H%M")
VV_DIR_LOGS="${WORKDIR}/VV/LOGS"
VV_DIR_KOUT="${WORKDIR}/VV/KOUT"
LOGFILE_FILENAME=$(basename "$0")_${DATESTAMP}.log
SCRIPT_LOGFILE=${VV_DIR_LOGS}/${LOGFILE_FILENAME}

function exitError {
    EXITMSG="${1:-ERROR}"
    echo "" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "####    ERROR    ####" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    tail "${SCRIPT_LOGFILE}"
    echo "" &>> "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${FUNCNAME[1]}[${BASH_LINENO[0]}]" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "${EXITMSG}" |& tee -a "${SCRIPT_LOGFILE}" || exit $LINENO
    echo "See ${SCRIPT_LOGFILE} for more details" || exit $LINENO
    # [[ $(type -t exitScript) == function ]] && exitScript || exit $LINENO
    exit $LINENO
}

mkdir -p "${VV_DIR_LOGS}" || exit $LINENO
touch "${SCRIPT_LOGFILE}" || exit $LINENO
printf "\n%s\n" "${SCRIPT_LOGFILE}" || exit $LINENO

echo "${WORKDIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

# echo ">>> Setup environment" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
# shellcheck source=/dev/null
# . "${WORKDIR}"/SDK_PHYTEC/environment-setup-aarch64-phytec-linux &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Setup .config" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make phytec_ti_defconfig phytec_ti_platform.config powerwatch.config &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Building the kernel . . . The patience is a virtue" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make -j"$(nproc)" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

printf "\n>>> Kernel has been successfully compiled\n" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO

KERNEL_OUT_DIR=${VV_DIR_KOUT}/${DATESTAMP}_$(make kernelversion)

echo "${KERNEL_OUT_DIR}" > "${VV_DIR_LOGS}"/VV_LAST_KERNEL_DIR
mkdir -vp "${KERNEL_OUT_DIR}"/boot &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Copy boot files" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v arch/arm64/boot/Image "${KERNEL_OUT_DIR}"/boot &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v .config "${KERNEL_OUT_DIR}"/boot/config &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dts "${KERNEL_OUT_DIR}"/boot &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dtb "${KERNEL_OUT_DIR}"/boot &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dtb "${KERNEL_OUT_DIR}"/boot/oftree &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Installing Modules" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
make INSTALL_MOD_PATH="${KERNEL_OUT_DIR}" modules_install &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Kernel has been successfully build, OUT files are located in:" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
printf ">>> %s\n\n" "${KERNEL_OUT_DIR}" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO