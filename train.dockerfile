FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime

RUN apt-get update && apt-get install -y \
    sudo \
    wget \
    vim
WORKDIR /opt

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    sh Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    rm -r Miniconda3-latest-Linux-x86_64.sh

ENV PATH /opt/miniconda3/bin:$PATH

COPY environment.train.yml .

RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    conda env create -n venv -f environment.train.yml && \
    conda init && \
    echo "conda activate venv" >> ~/.bashrc

ENV CONDA_DEFAULT_ENV venv && \
    PATH /opt/conda/envs/venv/bin:$PATH

RUN mkdir -p /home/proj/
COPY . /home/proj/
WORKDIR /home/proj/

CMD ["/bin/bash"]

