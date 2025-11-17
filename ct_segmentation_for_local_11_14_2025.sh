#!/bin/bash
#
# local_ct_segmentation_ppredict.sh
#
# Run Stroke_CT_Segmentation/ppredict.sh on LOCAL preprocessed files.
# All XNAT / SNIPR download/upload logic removed.
#
# Usage:
#   ./local_ct_segmentation_ppredict.sh \
#       /path/to/local_PREPROCESS_SEGM_dir \
#       [/workinginput] [/workingoutput] [/outputinsidedocker]
#
# Defaults (if not provided):
#   working_dir         = /workinginput
#   output_directory    = /workingoutput
#   final_output_dir    = /outputinsidedocker
#

set -euo pipefail

#if [[ $# -lt 1 ]]; then
#  echo "Usage: $0 /path/to/local_PREPROCESS_SEGM_dir [/workinginput] [/workingoutput] [/outputinsidedocker]"
#  exit 1
#fi

# Directory that already contains all the required preprocessed files
# (equivalent to what used to be SNIPR resource PREPROCESS_SEGM)
LOCAL_PREPROC_DIR="$1"
echo ${LOCAL_PREPROC_DIR}
# Internal directories (can be host-mounted in Docker)
working_dir="${2:-/workinginput}"
output_directory="${3:-/workingoutput}"
final_output_directory="${4:-/outputinsidedocker}"

if [[ ! -d "$LOCAL_PREPROC_DIR" ]]; then
  echo "ERROR: Input directory not found: $LOCAL_PREPROC_DIR"
  exit 1
fi

echo ">>> Local PREPROCESS_SEGM dir : $LOCAL_PREPROC_DIR"
echo ">>> Working directory         : $working_dir"
echo ">>> Output directory          : $output_directory"
echo ">>> Final output directory    : $final_output_directory"

# --------------------------------------------------------------------
# Prepare directories
# --------------------------------------------------------------------
#mkdir -p "$working_dir" "$output_directory" "$final_output_directory"

## Optional: clean old contents (comment out if you want to keep them)
#rm -f "${working_dir}"/*        || true
#rm -f "${output_directory}"/*   || true
#rm -f "${final_output_directory}"/* || true

# Copy local preprocessed files into working_dir
#echo ">>> Copying preprocessed files into working_dir..."
#cp -r "${LOCAL_PREPROC_DIR}"/* "${working_dir}/"
cp /input/SCANS/2/NIFTI/*.* "${working_dir}/"
cp /input/SCANS/2/PREPROCESS_SEGM/*.* "${output_directory}/"
# --------------------------------------------------------------------
# Run the segmentation (ppredict.sh) on the local files
# --------------------------------------------------------------------
echo ">>> Running /software/Stroke_CT_Segmentation/ppredict.sh ..."
/software/Stroke_CT_Segmentation/ppredict.sh \
  "${working_dir}" "${output_directory}"

# --------------------------------------------------------------------
# Collect results locally
# --------------------------------------------------------------------
echo ">>> Copying segmentation outputs to final_output_directory..."
cp "${output_directory}"/* "${final_output_directory}/" || true

echo
echo ">>> Segmentation finished."
echo ">>> Final outputs are in: ${final_output_directory}"
