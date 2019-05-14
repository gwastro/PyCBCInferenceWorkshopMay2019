#! /bin/bash

set -e

# data options
SEARCH_BEFORE=6
SEARCH_AFTER=2
PSD_INVLEN=4
PSD_SEG_LEN=16
PSD_STRIDE=8
PSD_DATA_LEN=1024

# data to use
FRAMES="H1:${PWD}/H-H1_GWOSC_4KHZ_R1-1126257415-4096.gwf L1:${PWD}/L-L1_GWOSC_4KHZ_R1-1126257415-4096.gwf"
CHANNELS="H1:GWOSC-4KHZ_R1_STRAIN L1:GWOSC-4KHZ_R1_STRAIN"
if [ ! -f H-H1_GWOSC_4KHZ_R1-1126257415-4096.gwf ]; then
wget https://www.gw-openscience.org/catalog/GWTC-1-confident/data/GW150914/H-H1_GWOSC_4KHZ_R1-1126257415-4096.gwf
wget https://www.gw-openscience.org/catalog/GWTC-1-confident/data/GW150914/L-L1_GWOSC_4KHZ_R1-1126257415-4096.gwf
fi

# create frame cache files that give meta-data and path to frames
echo "H H1_GWOSC_4KHZ_R1 1126257415 4096 file://localhost/${PWD}/H-H1_GWOSC_4KHZ_R1-1126257415-4096.gwf" > h1.lcf
echo "L L1_GWOSC_4KHZ_R1 1126257415 4096 file://localhost/${PWD}/L-L1_GWOSC_4KHZ_R1-1126257415-4096.gwf" > l1.lcf

# the following sets the number of cores to use; adjust as needed to
# your computer's capabilities
NPROCS=16

# name of the workflow
WORKFLOW_NAME="event"
TRIGGER_TIME=1126259462.42

# get coalescence time as an integer
TRIGGER_TIME_INT=${TRIGGER_TIME%.*}

# start and end time of data to read in
GPS_START_TIME=$((TRIGGER_TIME_INT - SEARCH_BEFORE - PSD_INVLEN))
GPS_END_TIME=$((TRIGGER_TIME_INT + SEARCH_AFTER + PSD_INVLEN))

# get PSD time
PSD_START_TIME=$((TRIGGER_TIME_INT - PSD_DATA_LEN/2))
PSD_END_TIME=$((TRIGGER_TIME_INT + PSD_DATA_LEN/2))

# path to output dir
OUTPUT_DIR=bbh

# input configuration files
CONFIG_PATH=${PWD}/ex_bbh_wf.ini
INFERENCE_CONFIG_PATH=${PWD}/ex_bbh_inf.ini

# directory that will be populated with HTML pages
HTML_DIR=${HOME}/public_html/inference_test

# run workflow generator on specific GPS end time
pycbc_make_inference_workflow --workflow-name ${WORKFLOW_NAME} \
    --config-files ${CONFIG_PATH} \
    --inference-config-file ${INFERENCE_CONFIG_PATH} \
    --output-dir ${OUTPUT_DIR} \
    --output-file ${WORKFLOW_NAME}.dax \
    --output-map output.map \
    --transformation-catalog ${WORKFLOW_NAME}.tc.txt \
    --gps-end-time ${GPS_END_TIME} \
    --config-overrides workflow:start-time:${GPS_START_TIME} \
                       workflow:end-time:${GPS_END_TIME} \
                       workflow-inference:data-seconds-before-trigger:$((${SEARCH_BEFORE} - ${PSD_INVLEN})) \
                       workflow-inference:data-seconds-after-trigger:$((${SEARCH_AFTER} + ${PSD_INVLEN})) \
                       workflow-datafind:datafind-pregenerated-cache-file-h1:${PWD}/h1.lcf \
                       workflow-datafind:datafind-pregenerated-cache-file-l1:${PWD}/l1.lcf \
                       inference:frame-files:"${FRAMES}" \
                       inference:psd-start-time:${PSD_START_TIME} \
                       inference:psd-end-time:${PSD_END_TIME} \
                       inference:psd-segment-length:${PSD_SEG_LEN} \
                       inference:psd-segment-stride:${PSD_STRIDE} \
                       inference:psd-inverse-length:${PSD_INVLEN} \
                       inference:nprocesses:${NPROCS} \
                       pegasus_profile-infernce:"condor\|request_cpus":${NPROCS} \
                       results_page:output-path:${HTML_DIR} \
                       results_page:analysis-subtitle:${WORKFLOW_NAME}

# submit workflow
cd ${OUTPUT_DIR}
pycbc_submit_dax --dax ${WORKFLOW_NAME}.dax \
    --no-create-proxy \
    --no-grid \
    --enable-shared-filesystem \
    --force-no-accounting-group
