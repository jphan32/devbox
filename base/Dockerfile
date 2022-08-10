###############################################################################
# Dockerfile Devbox
FROM nvidia/cuda:11.4.2-devel-ubuntu20.04
MAINTAINER Sangjoon Han <jphan@me.com>
###############################################################################

# Compile Enviroment
#RUN sed -i -re 's/([a-z]{2}.)?archive.ubuntu.com|security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && \
RUN chmod a=rwx,o+t /tmp && \
	rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get update && \
	apt-get install -y --no-install-recommends apt-utils && \
	apt-get dist-upgrade -y --no-install-recommends && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata && \
	apt-get install -y build-essential cmake pkg-config autoconf software-properties-common \
			gcc g++ gfortran zlib1g-dev cpio curl libboost-dev sudo xz-utils xauth x11-apps && \
	rm -rf /var/lib/apt/lists/*

# Defaults Timezone
RUN apt-get update && \
	ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && \
 	dpkg-reconfigure --frontend noninteractive tzdata && \
	rm -rf /var/lib/apt/lists/*

# Defaults Locale
RUN apt-get update && \
	apt-get install -y locales locales-all && \
	locale-gen "en_US.UTF-8" && \
	update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8"

# cuDNN
COPY cudnn-linux-x86_64-8.3.2.44_cuda11.5-archive.tar.xz /tmp/
WORKDIR /tmp/
RUN apt-mark hold libcudnn8 libcudnn8-dev && \
	tar Jxvf /tmp/cudnn-linux-x86_64-8.3.2.44_cuda11.5-archive.tar.xz && \
	mv /tmp/cudnn-linux-x86_64-8.3.2.44_cuda11.5-archive/include/* /usr/local/cuda/include/ && \
	mv /tmp/cudnn-linux-x86_64-8.3.2.44_cuda11.5-archive/lib/* /usr/local/cuda/lib64/ && \
	ldconfig && \
	rm -rf /tmp/*

# Running Enviroment
RUN apt-get update && \
	apt-get install -y vim openssh-server unzip git curl wget htop bash-completion && \
	rm -rf /var/lib/apt/lists/*
RUN locale-gen en_US.UTF-8
ENV CUDA_TOOLKIT_PATH=/usr/local/cuda
ENV CUDNN_INSTALL_PATH=/usr/local/cuda
ENV CUDA_HOME=/usr/local/cuda
ENV C_INCLUDE_PATH=${CUDA_HOME}/include:${C_INCLUDE_PATH}
ENV CPATH=${CUDA_HOME}/include:${CPATH}
ENV LIBRARY_PATH=${CUDA_HOME}/lib64:$LIBRARY_PATH
ENV PATH=${CUDA_HOME}/bin:$PATH
ENV TMP=/tmp

# User Setting
RUN echo "root:hRJk344Kt" | chpasswd
RUN useradd -ms /bin/bash admin && echo "admin:2dq6Uv8gZ" | chpasswd
RUN sed -i '12 i\Defaults        env_keep+="DISPLAY"' /etc/sudoers && \
	echo "admin  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

# Setting SSH Server
ENTRYPOINT ["service", "ssh", "start"]
COPY Xauthority.tmp /home/admin/.Xauthority
RUN sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/g' /etc/ssh/sshd_config && \
	chmod 600 /home/admin/.Xauthority && \
	chown admin:admin /home/admin/.Xauthority && \
	touch /root/.Xauthority && \
	touch /tmp/.DISPLAY.tmp && \
	chmod 600 /root/.Xauthority && \
	echo "printenv DISPLAY > /tmp/.DISPLAY.tmp" >> /home/admin/.bashrc && \
	echo "export DISPLAY=\`cat /tmp/.DISPLAY.tmp\`" >> /root/.bashrc && \
	echo "xauth add \$(xauth -f /home/admin/.Xauthority list|tail -1)" >> /root/.bashrc

# Setting SSH Server - Authorized_keys
# COPY container_key.pub /tmp/
# RUN mkdir -p /home/admin/.ssh && mkdir -p /root/.ssh && \
# 	mv /tmp/container_key.pub /tmp/authorized_keys && chmod 400 /tmp/authorized_keys && \
# 	cp /tmp/authorized_keys /home/admin/.ssh/authorized_keys && chown admin:admin /home/admin/.ssh/authorized_keys && \
# 	rm -rf /tmp/*
# RUN sed -e "\$aAuthorizedKeysFile .ssh/authorized_keys" /etc/ssh/sshd_config && \
# 	sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# Open Ports
EXPOSE 22

## Add Tini
#ENV TINI_VERSION=v0.19.0
#ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
#RUN chmod +x /usr/bin/tini
#ENTRYPOINT ["/usr/bin/tini", "--"]

# Add Dumb-ini
ENV DINI_VERSION=1.2.5
ENV DINI_ARCH=x86_64
ADD https://github.com/Yelp/dumb-init/releases/download/v${DINI_VERSION}/dumb-init_${DINI_VERSION}_${DINI_ARCH} /usr/bin/dini
RUN chmod +x /usr/bin/dini
ENTRYPOINT ["/usr/bin/dini", "--"]

CMD ["/bin/bash"]
