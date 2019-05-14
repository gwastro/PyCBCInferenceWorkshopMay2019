#! /bin/bash

set -e

WORKFLOW_NAME=emcee_pt_pptest
OUTPUT_DIR=pp

export OMP_NUM_THREADS=1

# run workflow generator
pycbc_make_inference_inj_workflow \
    --output-dir ${OUTPUT_DIR} \
    --workflow-name ${WORKFLOW_NAME} \
    --data-type simulated_data \
    --output-file ${WORKFLOW_NAME}.dax \
    --inference-config-file ex_pp_inf.ini \
    --config-files ex_pp_wf.ini \
    --config-overrides results_page:output-path:${PWD}/${OUTPUT_DIR}/results_html

# execute workflow
#cd ${OUTPUT_DIR}
#pycbc_submit_dax \
#   --no-create-proxy \
#   --no-grid \
#   --dax ${WORKFLOW_NAME}.dax \
#   --enable-shared-filesystem \
#   --force-no-accounting-group
