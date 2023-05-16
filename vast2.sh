#!/bin/bash

# Bash Script to Install kohya_ss on a Vast ai Machine
# tested with RTX 3090 and pytorch/pytorch_2.0.0-cuda11.7-cudnn8-runtime image
# Script need to be tested.
# Made with the Help of Github User Kuriot. Thanks :)

#install necessary tools
apt update
apt install -y libgl1 nano screen unzip # nano screen unzip optional
pip install cmake
pip install lit
pip install gdown #optional

# clone the repo
git clone https://github.com/bmaltais/

# switch into directory
cd kohya_ss

conda create -n kohya python=3.10.9
conda activate kohya
conda install pytorch==1.13.1 torchvision==0.14.1 xformers -c pytorch -c nvidia -c xformers
conda install -c conda-forge cudatoolkit=11.8.0
python3 -m pip install 'nvidia-cudnn-cu11>=8.6<9' tensorflow==2.11.* tensorrt==8.6.1 triton
python3 -m pip install accelerate==0.18.0
python3 -m pip install albumentations==1.3.0
python3 -m pip install altair==4.2.2
python3 -m pip install dadaptation==1.5
python3 -m pip install diffusers[torch]==0.10.2
python3 -m pip install easygui==0.98.3
python3 -m pip install einops==0.6.0
python3 -m pip install ftfy==6.1.1
python3 -m pip install gradio==3.28.1
python3 -m pip install lion-pytorch==0.0.6
python3 -m pip install opencv-python==4.7.0.68
python3 -m pip install pytorch-lightning==1.9.0
python3 -m pip install safetensors==0.2.6
python3 -m pip install toml==0.10.2
python3 -m pip install voluptuous==0.13.1
python3 -m pip install wandb==0.15.0
python3 -m pip install fairscale==0.4.13
python3 -m pip install requests==2.28.2
python3 -m pip install timm==0.6.12
python3 -m pip install huggingface-hub==0.13.3
python3 -m pip install lycoris_lora==0.1.4
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
ln -sr $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer.so.8 $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer.so.7
ln -sr $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer_plugin.so.8 $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer_plugin.so.7

#switch back
cd ..

# change gui.sh
rm kohya_ss/gui.sh

cat <<EOF > kohya_ss/gui.sh
#!/usr/bin/env bash

source ~/.miniconda3/etc/profile.d/conda.sh
conda activate kohya

export LD_LIBRARY_PATH=\$CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs:\$CONDA_PREFIX/lib/:\$CUDNN_PATH/lib:\$LD_LIBRARY_PATH
export MKL_THREADING_LAYER=1

SCRIPT_DIR=\$(cd -- "\$(dirname -- "\$0")" && pwd)

cd "\$SCRIPT_DIR"

python "\$SCRIPT_DIR/kohya_gui.py" "\$@"
EOF

# make executable
chmod +x kohya_ss/gui.sh
