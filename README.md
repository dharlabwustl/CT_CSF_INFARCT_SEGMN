## To use this segmentation algorithm you need to have: access to https://snipr.wustl.edu, and the all the pre-requisite steps need to be completed.

#!/bin/bash

# --------------------------------------------------------------------
# ct_csf_infarct_segmentation_redcap (docker workflow) - API key hidden
# --------------------------------------------------------------------

# 1) Docker image
imagename='registry.nrg.wustl.edu/docker/nrg-repo/sharmaatul11/ctegmentation:latest'

# 2) Create required host directories (bind-mounted into the container)
mkdir -p output input ZIPFILEDIR software NIFTIFILEDIR DICOMFILEDIR working workinginput workingoutput outputinsidedocker

# 3) Clean previous run contents (CAUTION)
rm -rf output/* input/* ZIPFILEDIR/* software/* NIFTIFILEDIR/* DICOMFILEDIR/* working/* workinginput/* workingoutput/* outputinsidedocker/*

# 4) XNAT variables (edit these before running)
SESSION_ID=REPLACE_WITH_SESSION_ID        # e.g., SNIPR_E03614
PROJECT=REPLACE_WITH_PROJECT_NAME         # e.g., SNIPR01
XNAT_USER=REPLACE_WITH_XNAT_USERNAME
XNAT_PASS=REPLACE_WITH_XNAT_PASSWORD
XNAT_HOST='https://snipr.wustl.edu'
SCRIPT_NAME='CSF_INFARCT_SEGMENTATION'
# API_KEY='REPLACE_WITH_REDCAP_API_KEY'   # Hidden for security

# 5) Optional resource limits from JSON
# DOCKER_MEM_FLAGS="--memory=16g --memory-reservation=8g"

# 6) Run Docker container (mounts and command match JSON, API key omitted)
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
    "${SCRIPT_NAME}" \
    "${API_KEY}"   # Uncomment if API key is required

###################################################################################################################

## Workflow: ct_ich_segmentation

**Docker Image:** `registry.nrg.wustl.edu/docker/nrg-repo/sharmaatul11/ctegmentation:latest`  
**Script Number:** 3  
**Memory:** Reserve 8000 MB | Limit 16000 MB  

### Commands
```bash
# 1. Create Required Directories
mkdir working input ZIPFILEDIR output NIFTIFILEDIR DICOMFILEDIR software workinginput workingoutput outputinsidedocker

# 2. Clean Old Contents
rm -r working/* input/* ZIPFILEDIR/* output/* NIFTIFILEDIR/* DICOMFILEDIR/* software/* workinginput/* workingoutput/* outputinsidedocker/*

# 3. Set Variables
SESSION_ID=REPLACE_WITH_SESSION_ID
PROJECT=REPLACE_WITH_PROJECT_NAME
XNAT_USER=REPLACE_WITH_XNAT_USERNAME
XNAT_PASS=REPLACE_WITH_XNAT_PASSWORD
XNAT_HOST='https://snipr.wustl.edu'
SCRIPT_NUMBER=3

# 4. Run Docker
docker run \
  -v $PWD/output:/output \
  -v $PWD/input:/input \
  -v $PWD/ZIPFILEDIR:/ZIPFILEDIR \
  -v $PWD/software:/software \
  -v $PWD/NIFTIFILEDIR:/NIFTIFILEDIR \
  -v $PWD/DICOMFILEDIR:/DICOMFILEDIR \
  -v $PWD/working:/working \
  -v $PWD/workinginput:/workinginput \
  -v $PWD/workingoutput:/workingoutput \
  -v $PWD/outputinsidedocker:/outputinsidedocker \
  -it registry.nrg.wustl.edu/docker/nrg-repo/sharmaatul11/ctegmentation:latest \
  /callfromgithub/downloadcodefromgithub.sh \
    ${SESSION_ID} ${XNAT_USER} ${XNAT_PASS} ${XNAT_HOST} \
    https://github.com/dharlabwustl/CT_CSF_INFARCT_SEGMN.git \
    ${SCRIPT_NUMBER}




