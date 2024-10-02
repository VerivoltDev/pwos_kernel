#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/gentgz.sh 

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

[[ -f "${VV_DIR_LOGS}"/VV_LAST_KERNEL_VER ]] && \
    KERNEL_VERSION=$(cat "${VV_DIR_LOGS}"/VV_LAST_KERNEL_VER) || \
    exitError "Fail to set Kernel version"

echo ">>> make ${KERNEL_VERSION}.tgz" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
cd "${KERNEL_OUT_DIR}" || exitError $LINENO
tar czvf "${KERNEL_VERSION}".tgz boot lib &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
# cd - &>> "${SCRIPT_LOGFILE}" || exitError $LINENO

echo ">>> ${KERNEL_VERSION}.tgz has been successfully generated and is located in:" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
printf ">>> ./xOUT that point to %s\n\n" "${KERNEL_OUT_DIR}" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO