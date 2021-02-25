FROM  nerfies-gpu:latest

USER root


ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"

WORKDIR /home/mk301/nerfies/nerfies


# Install cuda
# RUN CUDNN_DOWNLOAD_SUM=600267f2caaed2fd58eb214ba669d8ea35f396a7d19b94822e6b36f9f7088c20 && \
#   curl -fsSL http://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.2-linux-x64-v7.6.5.32.tgz -O && \
#   echo "$CUDNN_DOWNLOAD_SUM  cudnn-10.2-linux-x64-v7.6.5.32.tgz" | sha256sum -c - && \
#   gunzip cudnn-10.2-linux-x64-v7.6.5.32.tgz && \
#   tar --no-same-owner -xf cudnn-10.2-linux-x64-v7.6.5.32.tar -C /usr/local --wildcards 'cuda/lib64/libcudnn.so.*' && \
#   rm cudnn-10.2-linux-x64-v7.6.5.32.tar && \
#   ldconfig


# ENV CUDNN_VERSION 7.6.5.32
# LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

#   # cuDNN license: https://developer.nvidia.com/cudnn/license_agreement
# RUN CUDNN_DOWNLOAD_SUM=600267f2caaed2fd58eb214ba669d8ea35f396a7d19b94822e6b36f9f7088c20 && \
#   curl -fsSL http://developer.download.nvidia.com/compute/redist/cudnn/v7.6.5/cudnn-10.2-linux-x64-v7.6.5.32.tgz -O && \
#   echo "$CUDNN_DOWNLOAD_SUM  cudnn-10.2-linux-x64-v7.6.5.32.tgz" | sha256sum -c - && \
#   gunzip cudnn-10.2-linux-x64-v7.6.5.32.tgz && \
#   tar --no-same-owner -xf cudnn-10.2-linux-x64-v7.6.5.32.tar -C /usr/local && \
#   rm cudnn-10.2-linux-x64-v7.6.5.32.tar && \
#   ldconfig



# RUN apt-get update && apt-get install -y --no-install-recommends \
#     gnupg2 curl ca-certificates && \
#     curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub | apt-key add - && \
#     echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
#     echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
#     apt-get purge --autoremove -y curl \
#     && rm -rf /var/lib/apt/lists/*

# ENV CUDA_VERSION 11.0.3

# # For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     cuda-cudart-11-0=11.0.221-1 \
#     cuda-compat-11-0 \
#     && ln -s cuda-11.0 /usr/local/cuda && \
#     rm -rf /var/lib/apt/lists/*

# # Required for nvidia-docker v1
# RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
#     && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

# ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# # nvidia-container-runtime
# ENV NVIDIA_VISIBLE_DEVICES all
# ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
# ENV NVIDIA_REQUIRE_CUDA "cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 brand=tesla,driver>=450,driver<451"



  # Create the environment:
COPY ./nerfies/requirements.txt .
RUN pip install -r requirements.txt
RUN apt-get update && apt-get install openexr libopenexr-dev colmap ffmpeg
RUN pip install --upgrade jax jaxlib==0.1.59+cuda102 -f https://storage.googleapis.com/jax-releases/jax_releases.html

RUN pip install git+https://github.com/google/nerfies.git
RUN pip install "git+https://github.com/google/nerfies.git#egg=pycolmap&subdirectory=third_party/pycolmap"

RUN pip install numpy==1.19.3 mediapipe tensorflow_graphics flax frozendict ipyplot nbdime imageio-ffmpeg 

