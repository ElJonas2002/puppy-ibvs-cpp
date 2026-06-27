# NVIDIA image as base (CUDA 11.8 + cuDNN 8 is the maximum available version for Python 3.8)
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_VISIBLE_DEVICES=all
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics,video

# 2. Install prerequisites for ROS
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# 3. Install ROS Noetic official repository and security keys
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - 

# 4. Install ROS Noetic, OpenCV, g++ compiler, toolchains and building tools
RUN apt-get update && apt-get install -y \ 
    ros-noetic-ros-base \
    build-essential \
    cmake \
    pkg-config \
    libopencv-dev \
    ros-noetic-image-transport \
    ros-noetic-image-transport-plugins \
    ros-noetic-cv-bridge \
    python3-rosdep \
    python3-catkin-tools \
    && rm -rf /val/lib/apt/lists/*

# 5. Initialize rosdep
RUN rosdep init && \ 
    rosdep update --rosdistro=noetic

# 6. Configure OpenCV package version
RUN pkg-config --modversion opencv4

# 7. Select working directory
RUN mkdir -p /catkin_ws/src
WORKDIR /catkin_ws

# 8. Copy all project source files
COPY ./src ./src

# 9. Source ROS environment and build workspace
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && catkin_make"

# 10. Automatically source ROS environment settings on login
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc \
    && echo "source catkin_ws/devel/setup.bash" >> ~/.bashrc
    
# 11. Run main compiled binary file
CMD ["/bin/bash", "-c", "source devel/setup.bash && rosrun puppy-ibvs puppy-pov"]