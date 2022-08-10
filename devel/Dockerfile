###############################################################################
FROM znzlab/dev-python:v1.0.0
MAINTAINER Sangjoon Han <jphan32@znzlab.io>
###############################################################################

# TensorRT 8.2
WORKDIR /tmp
COPY nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.5.1-ga-20220505_1-1_amd64.deb /tmp/nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.5.1-ga-20220505_1-1_amd64.deb
ENV trt_os="ubuntu2004"
ENV trt_tag="cuda11.4-trt8.2.5.1-ga-20220505"
ENV trt_depend_version="8.2.5-1+cuda11.4"
ENV trt_version="8.2.5.1-1+cuda11.4"
RUN dpkg -i /tmp/nv-tensorrt-repo-${trt_os}-${trt_tag}_1-1_amd64.deb && \
	apt-key add /var/nv-tensorrt-repo-${trt_os}-${trt_tag}/*.pub && \
	apt-get update && \
	apt-get install -y  libnvinfer8=${trt_depend_version} libnvinfer-plugin8=${trt_depend_version} libnvparsers8=${trt_depend_version} libnvonnxparsers8=${trt_depend_version} \
						libnvinfer-bin=${trt_depend_version} libnvinfer-dev=${trt_depend_version} libnvinfer-plugin-dev=${trt_depend_version} libnvparsers-dev=${trt_depend_version} \
						libnvonnxparsers-dev=${trt_depend_version} libnvinfer-samples=${trt_depend_version} libnvinfer-doc=${trt_depend_version} \
						tensorrt=${trt_version} && \
	apt-get install -y  python3-libnvinfer=8.2.5-1+cuda11.4 graphsurgeon-tf=8.2.5-1+cuda11.4 \
						python3-libnvinfer-dev=${trt_depend_version} uff-converter-tf=${trt_depend_version} onnx-graphsurgeon=${trt_depend_version} && \
	rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Tensorflow + Keras
#WORKDIR /tmp
COPY tensorflow-2.9.1-cp38-cp38-linux_x86_64.whl /tmp/tensorflow-2.9.1-cp38-cp38-linux_x86_64.whl
RUN pip3 install /tmp/tensorflow-2.9.1-cp38-cp38-linux_x86_64.whl && rm -rf /tmp/*

# PyTorch
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113

## JupyterHub
#RUN apt-get update && \
# 	apt-get install -y libncurses5-dev nodejs npm && \
# 	rm -rf /var/lib/apt/lists/*
#RUN pip3 install jupyterhub && \
#	npm install -g configurable-http-proxy && \
#	pip3 install jupyterlab ipywidgets
#COPY jupyterhub_config.py /root/.jupyter/jupyterhub_config.py
#RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# JupyterLab
RUN apt-get update && \
 	apt-get install -y libncurses5-dev && \
 	mkdir -p /data/notebook && \
 	rm -rf /var/lib/apt/lists/*
RUN pip3 install jupyterlab ipywidgets
COPY jupyter_notebook_config.py.__jupyterlab /root/.jupyter/jupyter_notebook_config.py
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

# miniconda
ADD https://repo.anaconda.com/miniconda/Miniconda3-py38_4.11.0-Linux-x86_64.sh /tmp/Miniconda3-py38_4.11.0-Linux-x86_64.sh
RUN chmod a+x /tmp/Miniconda3-py38_4.11.0-Linux-x86_64.sh && \
	bash /tmp/Miniconda3-py38_4.11.0-Linux-x86_64.sh -b -p /root/miniconda && \
	/root/miniconda/bin/conda init bash && \
	/root/miniconda/bin/conda config --set auto_activate_base false && \
	echo "export PATH=$PATH:/root/miniconda/bin" >> /root/.bashrc && \
	rm -rf /tmp/*

# Open Ports
#EXPOSE 8000
EXPOSE 8888
EXPOSE 6006

# Run JupyterHub
WORKDIR /data
#COPY init_server.sh.__jupyterhub /root/init_server.sh
COPY init_server.sh.__jupyterlab /root/init_server.sh
RUN chmod a+x /root/init_server.sh
CMD bash -C '/root/init_server.sh';'bash'