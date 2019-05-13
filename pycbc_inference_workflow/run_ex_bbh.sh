#! /bin/bash

set -e

# data options
SEARCH_BEFORE=6
SEARCH_AFTER=2
PSD_INVLEN=4
PSD_SEG_LEN=16
PSD_STRIDE=8
PSD_DATA_LEN=1024

# the following sets the number of cores to use; adjust as needed to
# your computer's capabilities
NPROCS=16

# name of the workflow
WORKFLOW_NAME="event"
TRIGGER_TIME=1126259462.42

# start and end time of data to read in
GPS_START_TIME=$((TRIGGER_TIME_INT - SEARCH_BEFORE - PSD_INVLEN))
GPS_END_TIME=$((TRIGGER_TIME_INT + SEARCH_AFTER + PSD_INVLEN))

# get coalescence time as an integer
TRIGGER_TIME_INT=${TRIGGER_TIME%.*}

# get PSD time
PSD_START_TIME=$((TRIGGER_TIME_INT - PSD_DATA_LEN/2))
PSD_END_TIME=$((TRIGGER_TIME_INT + PSD_DATA_LEN/2))

# path to output dir
OUTPUT_DIR=output

# input configuration files
CONFIG_PATH=workflow.ini
INFERENCE_CONFIG_PATH=inference.ini

# directory that will be populated with HTML pages
HTML_DIR=${HOME}/public_html/inference_test

# run workflow generator on specific GPS end time
pycbc_make_inference_workflow --workflow-name ${WORKFLOW_NAME} \
    --config-files ${CONFIG_PATH} \
    --inference-config-file ${INFERENCE_CONFIG_PATH} \
    --output-dir ${OUTPUT_DIR} \
    --output-file ${WORKFLOW_NAME}.dax \
    --output-map ${OUTPUT_MAP_PATH} \
    --gps-end-time ${GPS_END_TIME} \
    --config-overrides workflow:start-time:${GPS_START_TIME} \
                       workflow:end-time:${GPS_END_TIME} \
                       workflow-inference:data-seconds-before-trigger:$((${SEARCH_BEFORE} - ${PSD_INVLEN})) \
                       workflow-inference:data-seconds-after-trigger:${SEARCH_AFTER} + ${PSD_INVLEN})) \
                       inference:psd-start-time:${PSD_START_TIME} \
                       inference:psd-end-time:${PSD_END_TIME} \
                       inference:psd-segment-length:${PSD_SEG_LEN} \
                       inference:psd-segment-stride:${PSD_STRIDE} \
                       inference:psd-inverse-length:${PSD_INVLEN} \
                       inference:nprocesses:${NPROCS} \
                       pegasus_profile-infernce:"condor\|request_cpus":${NPROCS} \
                       results_page:output-path:${HTML_DIR} \
                       results_page:analysis-subtitle:${WORKFLOW_NAME}

## submit workflow
#cd ${OUTPUT_DIR}
#pycbc_submit_dax --dax ${WORKFLOW_NAME}.dax \
#    --no-grid \
#    --enable-shared-filesystem \
#    --accounting-group ${ACCOUNTING_GROUP}
