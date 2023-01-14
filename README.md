## HRDA For VisDA Challenge

**by [Lukas Hoyer](https://lhoyer.github.io/), [Dengxin Dai](https://vas.mpi-inf.mpg.de/dengxin/), and [Luc Van Gool](https://scholar.google.de/citations?user=TwMib_QAAAAJ&hl=en)**

**[[Arxiv]](https://arxiv.org/abs/2204.13132)**
**[[Paper]](https://arxiv.org/pdf/2204.13132)**

## Overview

We have trained HRDA framework (using DAFormer backbone) on VisDA datasets. The adaptaion use only zerowaste-f as a source domain, and zerowaste-v2 as a target domain. All configurations and pretrained checkpoints are provided (no need to download anything). Note that the original README file appers as Original_README.md. 

## Setup Environment

For this project, we used python 3.8.5. We recommend setting up a new virtual
environment:

```shell
python -m venv ~/venv/hrda_visda
source ~/venv/hrda_visda/bin/activate
```

Unzip our code directory and install the requirements:

```shell
unzip HRDA_VisDA.zip
cd HRDA_VisDA
pip install -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
pip install mmcv-full==1.3.7 -f https://download.openmmlab.com/mmcv/dist/cu110/torch1.7/index.html # requires the other packages to be installed first
```

## Setup Datasets

**zerowaste-f:** Please, download zerowaste-f dataset and extract it to `data/zerowaste-f`.

**zerowaste-v2:** Please, download zerowaste-v2 dataset and extract it to `data/zerowaste-v2`.

The final folder structure should look like this:

```none
HRDA_VisDA
├── ...
├── data
│   |── zerowaste-f
│   │   ├── test
│   │   ├── train
│   │   └── val
│   └── zerowaste-v2-splits
│       ├── test
│       ├── train
│       └── val
├── ...
```

## Training

A training job can be launched using:

```shell
python run_experiments.py --config configs/hrda/zerowastev1HR2zerowastev2HR_hrda.py
```

## Predictions

After training a model, you can use it to output colorful predictions. In order to do so, please use the following command line:
```shell
python -m tools.test configs/hrda/zerowastev1HR2zerowastev2HR_hrda.py /path/to/pth/file --eval mIoU --show-dir output/predictions/folder/ --opacity 1
```
Please be sure to replace `/path/to/pth/file` with the path to your pretrained model, and `output/predictions/folder/` with the path to the output folder where colorful predictions will be saved.

If you wish, you can use our pretrained model that achieved 55.46% mIoU on zerowaste-v2 test set. This file can be found in `pretrained/hrda_v12v2_best_model.pth`.

We also provide a pretrained model that is trained on source-only images. This model can be found in the path `source_pretrained/segformer_on_zerowaste/iter_40000.pth`. This model achieved 38.3% mIoU on the test set of zerowaste-v2.

## Convert Color Predictions To Labels
In order to convert the colored predictions to labels, you may use the following script:

```shell
python -m tools.convert_visuals_to_labels /path/to/predictions/folder/ /output/labels/folder/
```
Where `/path/to/predictions/folder/` is the path to the colorful predictions and `/output/labels/folder/` is the folder to store the labels. 

## Hardware Description
We used one NVIDIA-A6000 GPU for both training and inference. 
GPU memory usage picked at 41GB, RAM memory is a bit hard to estimate because multiple users used the server during our development. 
Training time took about 2 days, and inference for the validation set took about 7 minutes. 

## Forward Pass Parameters
For one forward pass in inference time, HRDA uses approximately 160M parameters. We have used [the following](https://github.com/lhoyer/HRDA/issues/21) link to support our calculation. 

## Acknowledgements

HRDA is based on the following open-source projects. We thank their
authors for making the source code publicly available.

* [DAFormer](https://github.com/lhoyer/DAFormer)
* [MMSegmentation](https://github.com/open-mmlab/mmsegmentation)
* [SegFormer](https://github.com/NVlabs/SegFormer)
* [DACS](https://github.com/vikolss/DACS)
