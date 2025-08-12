## To use this segmentation algorithm you need to have: access to https://snipr.wustl.edu, and the all the pre-requisite steps need to be completed.

#!/bin/bash

# ---------------------------------------------
# ct_csf_infarct_segmentation (docker workflow)
# ---------------------------------------------

# 1) Docker image
imagename='registry.nrg.wustl.edu/docker/nrg-repo/sharmaatul11/ctegmentation:latest'

# 2) Create required host directories (bind-mounted into the container)
mkdir -p output input ZIPFILEDIR software NIFTIFILEDIR DICOMFILEDIR working workinginput workingoutput outputinsidedocker

# 3) Clean previous run contents (CAUTION)
rm -rf output/* input/* ZIPFILEDIR/* software/* NIFTIFILEDIR/* DICOMFILEDIR/* working/* workinginput/* workingoutput/* outputinsidedocker/*

# 4) XNAT variables (edit these)
SESSION_ID=REPLACE_WITH_SESSION_ID     # e.g., SNIPR_E03614
PROJECT=REPLACE_WITH_PROJECT_NAME      # e.g., SNIPR01
XNAT_USER=REPLACE_WITH_XNAT_USERNAME
XNAT_PASS=REPLACE_WITH_XNAT_PASSWORD
XNAT_HOST='https://snipr.wustl.edu'

# 5) Optional resource limits (reflects JSON reserve/limit memory)
#    Uncomment if you want Docker to enforce memory constraints.
# DOCKER_MEM_FLAGS="--memory=16g --memory-reservation=8g"

# 6) Run container (mounts mirror the JSON "mounts"; command mirrors "command-line")
docker run ${DOCKER_MEM_FLAGS} \
  -v "$PWD/output":/output \
  -v "$PWD/input":/input \
  -v "$PWD/ZIPFILEDIR":/ZIPFILEDIR \
  -v "$PWD/software":/software \
  -v "$PWD/NIFTIFILEDIR":/NIFTIFILEDIR \
  -v "$PWD/DICOMFILEDIR":/DICOMFILEDIR \
  -v "$PWD/working":/working \
  -v "$PWD/workinginput":/workinginput \
  -v "$PWD/workingoutput":/workingoutput \
  -v "$PWD/outputinsidedocker":/outputinsidedocker \
  -it "${imagename}" \
  /callfromgithub/downloadcodefromgithub.sh \
    "${SESSION_ID}" \
    "${XNAT_USER}" \
    "${XNAT_PASS}" \
    "${XNAT_HOST}" \
    "https://github.com/dharlabwustl/CT_CSF_INFARCT_SEGMN.git" \
    2
