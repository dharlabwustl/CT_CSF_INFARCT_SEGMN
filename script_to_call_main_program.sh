#!/bin/bash
SESSION_ID=${1}
export XNAT_USER=${2}
export XNAT_PASS=${3}
export XNAT_HOST=${4}
TYPE_OF_PROGRAM=${5}

input=$XNAT_HOST ##"one::two::three::four"
# Check if '::' is present
input=$XNAT_HOST ##"one::two::three::four"
# Check if '::' is present
if echo "$input" | grep -q "+"; then
  # Set the delimiter
  IFS='+'

  # Read the split words into an array
  read -ra ADDR <<< "$input"
  export XNAT_HOST=${ADDR[0]} 
  SUBTYPE_OF_PROGRAM=${ADDR[1]} 
else
export XNAT_HOST=${XNAT_HOST} 
    echo "'+' is not present in the string"
fi
echo ${TYPE_OF_PROGRAM}::TYPE_OF_PROGRAM
if [[ ${TYPE_OF_PROGRAM} == "SEGMENT_LOCAL_COMPUTER" ]] ;
directory_name=$SESSION_ID
then
    /software/ct_segmentation_for_local_11_14_2025.sh ${directory_name} $XNAT_USER $XNAT_PASS $XNAT_HOST /input /output
fi

if [[ ${TYPE_OF_PROGRAM} == 2 ]] ;
then
    /software/ct_segmentation.sh $SESSION_ID $XNAT_USER $XNAT_PASS $XNAT_HOST /input /output
fi
if [[ ${TYPE_OF_PROGRAM} == 'CSF_INFARCT_SEGMENTATION' ]] ;
then
    /software/ct_segmentation_03_18_2024.sh $SESSION_ID $XNAT_USER $XNAT_PASS $XNAT_HOST /input /output
fi

if [[ ${TYPE_OF_PROGRAM} == 3 ]] ;
then
    /software/ct_ich_segmentation.sh $SESSION_ID $XNAT_USER $XNAT_PASS $XNAT_HOST /input /output
fi

#if [[ ${TYPE_OF_PROGRAM} == 1 ]] ;
#then
#    /software/dicom2nifti_call_sessionlevel_selected.sh  ${SESSION_ID} $XNAT_USER $XNAT_PASS $XNAT_HOST
#fi
####################################
if [[ ${TYPE_OF_PROGRAM} == 'PROJECT_LEVEL' ]]; then
echo "I AM HERE"
if [[ ${SUBTYPE_OF_PROGRAM} == 'PROJECT_LEVEL_CSF_INFARCT_SEG' ]] ;
then
    /software/project_level_csf_infarct_seg.sh $SESSION_ID $XNAT_USER $XNAT_PASS "${ADDR[0]}"  "${ADDR[2]}" "${ADDR[3]}"
fi
if [[ ${SUBTYPE_OF_PROGRAM} == 'PROJECT_LEVEL_ICH_SEG' ]] ;
then
    /software/project_level_ich_seg.sh $SESSION_ID $XNAT_USER $XNAT_PASS "${ADDR[0]}"  "${ADDR[2]}" "${ADDR[3]}"
fi
fi