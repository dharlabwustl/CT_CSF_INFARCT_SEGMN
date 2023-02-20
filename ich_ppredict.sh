#!/bin/bash
normalized_dir=${1}
gpu_id=0
program_directory=/software/unet_ich_edema
model_id=72

for group_id in {1..10} 
do
   name_dir_output=${program_directory}/Results_model_${model_id}/group_${group_id}
   mkdir $name_dir_output

   python ${program_directory}/main.py --network=unet --gpu_id=${gpu_id} --model_in_path=${program_directory}/models/group_${group_id}/model_${model_id}/model_${model_id}-${model_id} --data_in=${normalized_dir} --output_dir=${name_dir_output} --manual_splits=${normalized_dir}/manual_splits.txt
   # python main.py --network=unet --gpu_id=${gpu_id} --model_in_path=./models/group_${group_id}/model_${model_id}/model_${model_id}-${model_id} --data_in=./normalized --output_dir=${name_dir_output} --manual_splits=./manual_splits.txt
done

model_id=114

for group_id in {1..10} 
do
   name_dir_output=${program_directory}/Results_model_${model_id}/group_${group_id}
   mkdir $name_dir_output

   python ${program_directory}/main.py --network=unet --gpu_id=${gpu_id} --model_in_path=${program_directory}/models/group_${group_id}/model_${model_id}/model_${model_id}-${model_id} --data_in=${normalized_dir} --output_dir=${name_dir_output} --manual_splits=${normalized_dir}/manual_splits.txt
   # python main.py --network=unet --gpu_id=${gpu_id} --model_in_path=./models/group_${group_id}/model_${model_id}/model_${model_id}-${model_id} --data_in=./normalized --output_dir=${name_dir_output} --manual_splits=./manual_splits.txt
done

####ich
python ${program_directory}/ensemble_outputs.py --path ${program_directory}/Results_model_114/group_1 --class_id 1 --ngroups 10

####edema
python ${program_directory}/ensemble_outputs.py --path ${program_directory}/Results_model_72/group_1 --class_id 2 --ngroups 10


