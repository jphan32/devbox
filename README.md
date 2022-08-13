# devbox
Dockerfile for Tensorflow, PyTorch, TensorRT

---
## 대용량 파일을 받으셔야 합니다.
### base/
	* cudnn-linux-x86_64-8.3.2.44_cuda11.5-archive.tar.xz
		* https://developer.nvidia.com/rdp/cudnn-download
### runtime/
	* l_openvino_toolkit_p_2022.1.0.643_offline.sh
		* [Download Intel® Distribution of OpenVINO™ Toolkit](https://www.intel.com/content/www/us/en/developer/tools/openvino-toolkit/download.html)
		* 
### devel/
	* nv-tensorrt-repo-ubuntu2004-cuda11.4-trt8.2.5.1-ga-20220505_1-1_amd64.deb
		* https://developer.nvidia.com/nvidia-tensorrt-8x-download
	* tensorflow-2.9.1-cp38-cp38-linux_x86_64.whl
		* https://www.tensorflow.org/install/pip?hl=ko#ubuntu-macos