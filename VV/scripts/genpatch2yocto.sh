#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/genpatch2yocto.sh 

: "${WORKDIR:?err}"

DATESTAMP=$(date +"%y%m%d.%H%M")
VV_DIR_LOGS="${WORKDIR}/VV/LOGS"
LOGFILE_FILENAME=$(basename "$0")_${DATESTAMP}.log
SCRIPT_LOGFILE=${VV_DIR_LOGS}/${LOGFILE_FILENAME}

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

PATCHES_OUT_DIR="${KERNEL_OUT_DIR}"/patches
if [[ -d ${PATCHES_OUT_DIR} ]] 
then
    rm -vrf   "${PATCHES_OUT_DIR:?}"/* &>> "${SCRIPT_LOGFILE}" || \
    exitError $LINENO
else
    mkdir -vp "${PATCHES_OUT_DIR}" &>> "${SCRIPT_LOGFILE}" || \
    exitError $LINENO
fi

# Makefile
echo ">>> patch of Makefile" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
git     diff v6.1.69-09.02.00.005-phy3 \
        Makefile \
        > "${PATCHES_OUT_DIR}"/pw_v6.1.69_Makefile.patch || exitError $LINENO

# k3-am642-phyboard-electra-rdk.dts
echo ">>> patch of k3-am642-phyboard-electra-rdk.dts" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v   arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts \
        arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts.bkp \
        &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

cp -v   arch/arm64/boot/dts/ti/k3-am642-powerwatch-v0.4.dts \
        arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts \
        &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

git     diff v6.1.69-09.02.00.005-phy3 \
        arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts \
        > "${PATCHES_OUT_DIR}"/pw_v6.1.69_k3-am642-phyboard-electra-rdk.patch || exitError $LINENO

mv -v   arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts.bkp \
        arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts \
        &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

# phytec_ti_platform.config
echo ">>> patch of phytec_ti_platform.config" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
cp -v   arch/arm64/configs/phytec_ti_platform.config \
        arch/arm64/configs/phytec_ti_platform.config.bkp \
        &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

cat     arch/arm64/configs/powerwatch.config \
        >> arch/arm64/configs/phytec_ti_platform.config \
        || exitError $LINENO

git     diff v6.1.69-09.02.00.005-phy3 \
        arch/arm64/configs/phytec_ti_platform.config \
        > "${PATCHES_OUT_DIR}"/pw_v6.1.69_phytec_ti_platform.config.patch || exitError $LINENO

mv -v   arch/arm64/configs/phytec_ti_platform.config.bkp \
        arch/arm64/configs/phytec_ti_platform.config \
        &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> Pacht files has been successfully generated, files are located in:" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
printf ">>> ./xOUT/patches that point to %s/patches\n\n" "${KERNEL_OUT_DIR}" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO