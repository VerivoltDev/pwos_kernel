#!/bin/bash

## WORKDIR=$PWD ./VV/scripts/init_backports.bash

: "${WORKDIR:?err}"

VV_DIR_DOWN="${WORKDIR}/VV/DOWN"
VV_DIR_LOGS="${WORKDIR}/VV/LOGS"

LAIRD_BACKPORTS_DIR="${WORKDIR}/summit-backports-12.29.0.22"
LAIRD_BACKPORTS_URL=https://github.com/LairdCP/Sterling-LWB-and-LWB5-Release-Packages/releases/download/LRD-REL-12.29.0.22
LAIRD_BACKPORTS_FILE=summit-backports-12.29.0.22.tar.bz2
LAIRD_BACKPORTS_CHECKSUM=704a5383f8af60bf74f3f5413c63c088804c6c97

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

### BACKPORTS ###

if [[ -f ${VV_DIR_DOWN}/${LAIRD_BACKPORTS_FILE} ]] && echo "${LAIRD_BACKPORTS_CHECKSUM}  ${VV_DIR_DOWN}/${LAIRD_BACKPORTS_FILE}" | shasum -c
then
    echo ">>> Skip download Laird Backports, file found: ${LAIRD_BACKPORTS_FILE}" |& tee -a "${SCRIPT_LOGFILE}"
else
    rm -vf "${VV_DIR_DOWN}"/${LAIRD_BACKPORTS_FILE} &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    echo ">>> Downloading Laird Backports" |& tee -a "${SCRIPT_LOGFILE}"
    wget ${LAIRD_BACKPORTS_URL}/${LAIRD_BACKPORTS_FILE} -P "${VV_DIR_DOWN}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
fi

if [[ -d ${LAIRD_BACKPORTS_DIR} ]]
then
    echo ">>> Removing Laird Backports Dir" |& tee -a "${SCRIPT_LOGFILE}"
    rm -rf "${LAIRD_BACKPORTS_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
fi

if [[ -f ${VV_DIR_DOWN}/${LAIRD_BACKPORTS_FILE} ]]
then
    # echo ">>> Check Laird Backports file integrity" |& tee -a "${SCRIPT_LOGFILE}" |& tee -a "${SCRIPT_LOGFILE}"
    # echo "${LAIRD_BACKPORTS_CHECKSUM}  ${VV_DIR_DOWN}/${LAIRD_BACKPORTS_FILE}" | shasum -c &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    echo ">>> Uncompressing Laird Backports" |& tee -a "${SCRIPT_LOGFILE}"
    # mkdir -vp "${LAIRD_BACKPORTS_DIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    tar xvf "${VV_DIR_DOWN}"/${LAIRD_BACKPORTS_FILE} -C "${WORKDIR}" &>> "${SCRIPT_LOGFILE}" || exitError $LINENO
    printf ">>> Laird Backports has been successfully set up\n" |& tee -a "${SCRIPT_LOGFILE}" || exitError $LINENO
fi
