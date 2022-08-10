###############################################################################
FROM jphan32/devbox:base
MAINTAINER Sangjoon Han <jphan@me.com>
###############################################################################

# Python
RUN apt-get update && \
	apt-get install -y python3 python3-dev python3-distutils python3-tk && \
	apt-get install -y libsnappy-dev && \
	rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
RUN python3 /tmp/get-pip.py && \
	rm -rf /tmp/*
RUN pip3 install --upgrade setuptools wheel nose cython

# MKL
WORKDIR /tmp
ADD https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB /tmp/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
RUN apt-key add /tmp/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
	sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && \
	apt-get update && \
	apt-get install -y intel-mkl-2020.0-088 && \
	rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
ENV MKL_ROOT_DIR=/opt/intel/mkl
RUN echo "/opt/intel/mkl/lib/intel64" > /etc/ld.so.conf.d/intel_mkl.conf && \
	ldconfig && \
	rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

#### OpenBLAS
#WORKDIR /tmp
#ENV OPENBLAS_VERSION=v0.3.20
#RUN git clone --depth 1 -b ${OPENBLAS_VERSION} https://github.com/xianyi/OpenBLAS.git
#### Show CPU Architecture : gcc -march=native -Q --help=target | grep march
##ENV MARCH=COOPERLAKE (Xeon gen3)
##ENV MARCH=SKYLAKEX
#### RUN cd OpenBLAS && make -j"$(nproc)" FC=gfortran TARGET=${TARGET_MARCH} BINARY=64 && make PREFIX=/opt/OpenBLAS install && \
#RUN cd OpenBLAS && make -j"$(nproc)" FC=gfortran BINARY=64 && make PREFIX=/opt/OpenBLAS install && \
#	rm -rf /tmp/*
#RUN echo "/opt/OpenBLAS/lib" | tee -a /etc/ld.so.conf.d/openblas.conf && ldconfig

# Numpy
ENV NUMPY_VERSION=1.23.1
COPY numpy.mkl.site.cfg /root/.numpy-site.cfg
#COPY numpy.openblas.site.cfg /root/.numpy-site.cfg
RUN pip3 install numpy==${NUMPY_VERSION} --no-binary numpy && rm -rf /root/.numpy-site.cfg

# OpenVINO
WORKDIR /tmp
COPY l_openvino_toolkit_p_2022.1.0.643_offline.sh /tmp/l_openvino_toolkit_p_2022.1.0.643_offline.sh
RUN chmod a+x l_openvino_toolkit_p_2022.1.0.643_offline.sh && \
	./l_openvino_toolkit_p_2022.1.0.643_offline.sh -a -s --eula accept && \
	/opt/intel/openvino_2022/install_dependencies/install_openvino_dependencies.sh -y && \
	# echo "source /opt/intel/openvino_2022/setupvars.sh" >> /etc/bash.bashrc && \
	echo "/opt/intel/openvino_2022/runtime/3rdparty/tbb/lib" > /etc/ld.so.conf.d/openvino.conf && \
	echo "/opt/intel/openvino_2022/runtime/3rdparty/hddl/lib" >> /etc/ld.so.conf.d/openvino.conf && \
	echo "/opt/intel/openvino_2022/runtime/lib/intel64" >> /etc/ld.so.conf.d/openvino.conf && \
	ldconfig && \
	rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# OpenCV + ffmpeg
RUN apt-get update && \
	apt-get install -y ffmpeg libgtk-3-dev libavcodec-dev libavformat-dev libswscale-dev libgl1-mesa-dri \
	libjpeg-dev libpng-dev libpng++-dev libtiff5-dev libdc1394-22-dev opencl-headers mesa-utils libgtkgl2.0-dev \
	qtbase5-dev libxine2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgtk2.0-dev libgtkglext1-dev \
	libgstreamer-plugins-good1.0-dev libavfilter-dev libx11-dev libglu1-mesa-dev libx264-dev libva-dev \
	libavresample-dev libeigen3-dev libv4l-dev v4l-utils libavfilter-dev libxvidcore-dev libcurl4-openssl-dev \
	freeglut3-dev libgoogle-glog-dev protobuf-compiler libprotobuf-dev libhdf5-dev libgflags-dev libgphoto2-dev && \
	rm -rf /var/lib/apt/lists/*

ENV OPENCV_VERSION=4.5.5
WORKDIR /tmp
RUN git clone --depth 1 -b ${OPENCV_VERSION} https://github.com/Itseez/opencv_contrib.git && \
	git clone --depth 1 -b ${OPENCV_VERSION}-openvino-2022.1.0 https://github.com/Itseez/opencv.git
RUN mkdir opencv/build && cd opencv/build && \
	cmake -D CMAKE_BUILD_TYPE=Release \
		  -D CMAKE_INSTALL_PREFIX=/usr/local/opencv \
		  -D ENABLE_FAST_MATH=ON \
		  -D ENABLE_PRECOMPILED_HEADERS=ON \
		  -D BUILD_EXAMPLES=OFF \
		  -D BUILD_ANDROID_EXAMPLES=OFF \
		  -D BUILD_PERF_TESTS=OFF \
		  -D BUILD_DOCS=OFF \
		  -D BUILD_TESTS=OFF \
		  -D BUILD_opencv_dnn=ON \
		  -D WITH_FREETYPE=ON \
#		  -D CUDA_GENERATION=Ampere \
		  -D CUDA_ARCH_BIN="7.5, 8.0, 8.6" \
		  -D CUDA_ARCH_PTX="7.5, 8.0, 8.6" \
		  -D CUDA_FAST_MATH=ON \
		  -D WITH_CUDA=ON \
		  -D WITH_CUBLAS=ON \
		  -D WITH_NVCUVID=ON \
		  -D WITH_OPENGL=ON \
		  -D WITH_TBB=ON \
		  -D WITH_QT=ON \
		  -D WITH_IPP_A=ON \
		  -D WITH_XINE=ON \
		  -D WITH_INF_ENGINE=ON \
		  -D INF_ENGINE_RELEASE=2022010000 \
		  -D WITH_NGRAPH=ON \
		  -D InferenceEngine_DIR="/opt/intel/openvino_2022/runtime/cmake" \
		  -D ngraph_DIR="/opt/intel/openvino_2022/runtime/cmake" \
		  -D OpenVINO_DIR="/opt/intel/openvino_2022/runtime/cmake" \
		  -D MKL_WITH_TBB=ON \
		  -D MKL_ROOT_DIR=/opt/intel/mkl \
		  -D EIGEN_INCLUDE_PATH=/usr/include/eigen3 \
		  -D BUILD_opencv_python3=ON \
		  -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
		  -D PYTHON3_EXECUTABLE=$(which python3) \
 		  -D PYTHON3_PACKAGES_PATH=$(python3 -c "import site; print(site.getsitepackages()[0])") \
		  -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy, os; print(os.path.join(numpy.__path__[0], 'core/include'))") \
		  -D PYTHON3_INCLUDE_DIR=$(python3 -c "from sysconfig import get_path; print(get_path('include'))") \
		  -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules/ .. && \
	make -j"$(nproc)" && make install && \
	echo "/usr/local/opencv/lib" | tee -a /etc/ld.so.conf.d/opencv.conf && ldconfig && \
	rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Python Requirements
WORKDIR /tmp
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r requirements.txt && rm -rf /tmp/*


WORKDIR /root/
# COPY init_server.sh /root/init_server.sh
# RUN chmod a+x /root/init_server.sh
# CMD bash -C '/root/init_server.sh';'bash'
CMD ["/bin/bash"]