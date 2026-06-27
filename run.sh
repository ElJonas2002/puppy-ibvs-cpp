#!/bin/bash

# Automatically detect computer IP
LAPTOP_IP=$(hostname -I | awk '{print $1}')

# PuppyPi IP — passed like an argument or detected via ping
PUPPYPI_IP=${1:-""}

# If not IP written, shows an example of how to use the command
if [ -z "$PUPPYPI_IP" ]; then
    echo "Use: ./run.sh <IP_PUPPYPI>"
    echo "Example: ./run.sh 192.168.100.166"
    exit 1
fi

# Announced hostname
PUPPYPI_HOSTNAME=raspberrypi

# IP for the application
echo "Laptop IP:  $LAPTOP_IP"
echo "PuppyPi IP: $PUPPYPI_IP"

# Allow access to display
xhost +local:docker

# Execute image container
docker run -it \
    --gpus all \
    --network host \
    --add-host $PUPPYPI_HOSTNAME:$PUPPYPI_IP \
    -e ROS_MASTER_URI=http://$PUPPYPI_IP:11311 \
    -e ROS_IP=$LAPTOP_IP \
    -e PUPPYPI_IP=$PUPPYPI_IP \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/resources/camera_params.npz:/camera_params.npz \
    puppy-ibvs