#!/bin/bash

# Bash Script to Install kohya_ss on a Vast ai Machine
# tested with RTX 3090 and pytorch/pytorch_2.0.0-cuda11.7-cudnn8-runtime image

#install necessary tools
apt update
apt install -y libgl1 nano screen unzip # nano screen unzip optional
pip install cmake
pip install lit
pip install gdown #optional

# clone the repo
git clone https://github.com/bmaltais/

cd kohya_ss

conda create -n kohya python=3.10.9
conda activate kohya
conda install pytorch==1.13.1 torchvision==0.14.1 xformers -c pytorch -c nvidia -c xformers
conda install -c conda-forge cudatoolkit=11.8.0
python3 -m pip install 'nvidia-cudnn-cu11>=8.6<9' tensorflow==2.11.* tensorrt==8.6.1 triton
mkdir -p $CONDA_PREFIX/etc/conda/activate.d
echo 'CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/:$CUDNN_PATH/lib' >> $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
source $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
ln -sr $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer.so.8 $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer.so.7
ln -sr $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer_plugin.so.8 $CONDA_PREFIX/lib/python3.10/site-packages/tensorrt_libs/libnvinfer_plugin.so.7

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
