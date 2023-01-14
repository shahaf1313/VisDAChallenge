echo Path to .pth dir: $1
echo Path to config file: $2
echo GPU to use: $3
echo Out folder: $4
echo Submition text: $5
source /opt/anaconda3/bin/activate base
conda activate hrda
BASE_PATH=/data1/Shahaf/hrda_clean/HRDA
cd $BASE_PATH
echo Current directory: `pwd`
PATH_TO_PTH_FILES=`ls $1 | grep 0.pth`
evalai set_token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY5MTkxNzQyMiwianRpIjoiOTRkYjIzM2U2OTkwNDAxM2E2ODVkNmE0OTJiODZkZDMiLCJ1c2VyX2lkIjoyMzIxNH0.b_KwR9N7yhRLzYUKbnucLxddfrnMFuTpXT_v9yXtcLA
for FILE in $PATH_TO_PTH_FILES
do
    ITER=`echo $FILE | cut -b 6-7`k
    FILE_PATH=$1$FILE
    CUDA_VISIBLE_DEVICES=$3 python -m tools.test $2 $FILE_PATH --eval mIoU --show-dir $4uda_labels_$ITER --opacity 1
    python -m tools.convert_visuals_to_labels $4uda_labels_$ITER $4uda_$ITER
    mkdir ~/tmp/
    cp -r $4uda_$ITER ~/tmp/
    mv ~/tmp/uda_$ITER ~/tmp/uda
    cp -r $4source_only ~/tmp/
    cd ~/tmp
    zip -r $ITER.zip uda source_only
    mv $ITER.zip $4
    cd $BASE_PATH
    rm -rf ~/tmp
    SUBMITION_PRINT="y\n$5_$ITER\n\n\n\n"
    printf "$SUBMITION_PRINT" | evalai challenge 1806 phase 3516 submit --file $4$ITER.zip  --private
done
