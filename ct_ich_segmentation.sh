#!/bin/bash
export XNAT_USER=${2}
export XNAT_PASS=${3}
export XNAT_HOST=${4}
sessionID=${1}
working_dir=/workinginput
output_directory=/workingoutput

final_output_directory=/outputinsidedocker

copyoutput_to_snipr(){
sessionID=$1
scanID=$2
resource_dirname=$4 #"MASKS" #sys.argv[4]
file_suffix=$5
output_dir=$3
echo " I AM IN copyoutput_to_snipr "
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
uploadfile()" ${sessionID} ${scanID} ${output_dir} ${resource_dirname} ${file_suffix}  # ${infarctfile_present}  ##$static_template_image $new_image $backslicenumber #$single_slice_filename

}


copy_masks_data() {
echo " I AM IN copy_masks_data "
# rm -r /ZIPFILEDIR/*
sessionID=${1}
scanID=${2}
resource_dirname=${3} #str(sys.argv[4])
output_dirname=${4}  #str(sys.argv[3])
echo output_dirname::${output_dirname}
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
downloadfiletolocaldir()" ${sessionID}  ${scanID}  ${resource_dirname}  ${output_dirname}    ### ${infarctfile_present}  ##$static_template_image $new_image $backslicenumber #$single_slice_filename


}
copy_allfiles_data() {
echo " I AM IN copy_masks_data "
# rm -r /ZIPFILEDIR/*
sessionID=${1}
scanID=${2}
resource_dirname=${3} #str(sys.argv[4])
output_dirname=${4}  #str(sys.argv[3])
echo output_dirname::${output_dirname}
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
downloadallfiletolocaldir()" ${sessionID}  ${scanID}  ${resource_dirname}  ${output_dirname}    ### ${infarctfile_present}  ##$static_template_image $new_image $backslicenumber #$single_slice_filename


}
#copy_scan_data() {
#		echo " I AM IN copy_scan_data "
## rm -r /ZIPFILEDIR/*
## rm -r ${working_dir}/*
## rm -r ${output_dir}/*
#sessionID=$1
#dir_to_receive_the_data=${2}
#resource_dir=${3}
#    # sessionId=sys.argv[1]
#    # dir_to_receive_the_data=sys.argv[2]
#    # resource_dir=sys.argv[3]
## scanID=$2
#python -c "
#import sys
#sys.path.append('/Stroke_CT_Processing');
#from download_with_session_ID import *;
#get_relevantfile_in_A_DIRECTORY()" ${sessionID}  ${dir_to_receive_the_data} ${resource_dir}
#
#}







# #####################################################
get_nifti_scan_uri(){
# csvfilename=sys.argv[1]
# dir_to_save=sys.argv[2]
# echo " I AM IN copy_scan_data "
# rm -r /ZIPFILEDIR/*

sessionID=$1
working_dir=${2}
output_csvfile=${3}
rm -r ${working_dir}/*
output_dir=$(dirname ${output_csvfile})
rm -r ${output_dir}/*
# scanID=$2
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
call_decision_which_nifti()" ${sessionID}  ${working_dir} ${output_csvfile}

}




copy_scan_data() {
csvfilename=${1} #sys.argv[1]
dir_to_save=${2} #sys.argv[2]
# 		echo " I AM IN copy_scan_data "
# rm -r /ZIPFILEDIR/*
# rm -r ${working_dir}/*
# rm -r ${output_dir}/*
# sessionID=$1
# # scanID=$2
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
downloadniftiwithuri_withcsv()" ${csvfilename}  ${dir_to_save}


}


getmaskfilesscanmetadata()
{
# def get_maskfile_scan_metadata():
sessionId=${1} #sys.argv[1]
scanId=${2} # sys.argv[2]
resource_foldername=${3} # sys.argv[3]
dir_to_save=${4} # sys.argv[4]
csvfilename=${5} # sys.argv[5]
/opt/conda/bin/python -c "
import sys
sys.path.append('/software');
from download_with_session_ID import *;
get_maskfile_scan_metadata()" ${sessionId}  ${scanId}  ${resource_foldername} ${dir_to_save} ${csvfilename}
}

#########################################################################
## GET THE SINGLE CT NIFTI FILE NAME AND COPY IT TO THE WORKING_DIR
niftifile_csvfilename=${working_dir}/'this_session_final_ct.csv'
get_nifti_scan_uri ${sessionID}  ${working_dir} ${niftifile_csvfilename}
copy_scan_data ${niftifile_csvfilename} ${working_dir}
working_dir=/workinginput
output_directory=/workingoutput

final_output_directory=/outputinsidedocker
############################
#/software/Stroke_CT_Processing/stroke_ct_processing_1.sh ${working_dir} ${output_directory}
#/software/Stroke_CT_Processing/step4_bet.sh ${output_directory}
#/software/Stroke_CT_Processing/stroke_ct_processing_2.sh ${output_directory} ${output_directory}

######################
while IFS=',' read -ra array; do
scanID=${array[2]}
echo sessionId::${sessionID}
echo scanId::${scanID}
done < <( tail -n +2 "${niftifile_csvfilename}" )
resource_dirname='PREPROCESS_SEGM'
output_dirname=${working_dir}

echo working_dir::${working_dir}
echo output_dirname::${output_dirname}
copy_allfiles_data   ${sessionID}  ${scanID} ${resource_dirname} ${output_dirname}
####################
#/bin/bash -i -c
#/root/anaconda3/bin/conda activate tf
#/software/unet_ich_edema/ppredict.sh ${output_dirname}

######################################################################################################################
##/root/anaconda3/bin/conda deactivate
#if [[ "$STR" == *"$SUB"* ]]; then
#  echo "It's there."
#fi

for file in /software/unet_ich_edema/Results_model_114/*.nii*
do
  if [[ "${file}" != *"ERICH"* ]]; then
    echo "It's there."
      new_filename=${file%.nii.gz_class1*}_class1.nii.gz
      cp ${new_filename} ${final_output_directory}/
  fi


done

for file in /software/unet_ich_edema/Results_model_72/*.nii*
do
    if [[ "${file}" != *"ERICH"* ]]; then
      echo "It's there."
  new_filename=${file%.nii.gz_class2*}_class2.nii.gz
  cp ${new_filename} ${final_output_directory}/
  fi
done
######################################################################################################################

######################################################################################################################
# COPY IT TO THE SNIPR RESPECTIVE SCAN RESOURCES

snipr_output_foldername="MASKS"
file_suffixes=(  .nii.gz .nii .txt ) #sys.argv[5]
for file_suffix in ${file_suffixes[@]}
do
    echo "COPYING FILES TO ${snipr_output_foldername} "
    copyoutput_to_snipr  ${sessionID} ${scanID} "${final_output_directory}"  ${snipr_output_foldername}  ${file_suffix}
done
######################################################################################################################



################################################################################################################
#
### GET THE RESPECTIVS MASKS NIFTI FILE NAME AND COPY IT TO THE WORKING_DIR
#
######################################################################################
#resource_dirname='MASKS'
#output_dirname=${working_dir}

#echo working_dir::${working_dir}
#echo output_dirname::${output_dirname}
#copy_masks_data   ${sessionID}  ${scanID} ${resource_dirname} ${output_dirname}
#######################################################################################################################
### CALCULATE EDEMA BIOMARKERS
#nwucalculation_each_scan
#######################################################################################################################
### COPY IT TO THE SNIPR RESPECTIVE SCAN RESOURCES
#snipr_output_foldername="EDEMA_BIOMARKER"
#file_suffixes=(  .pdf .mat .csv ) #sys.argv[5]
#for file_suffix in ${file_suffixes[@]}
#do
#    copyoutput_to_snipr  ${sessionID} ${scanID} "${final_output_directory}"  ${snipr_output_foldername}  ${file_suffix}
#done
#######################################################################################################################

