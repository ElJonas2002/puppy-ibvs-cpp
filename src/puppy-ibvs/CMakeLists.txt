# ---ROS Noetic targets Python 3 and requires at least 3.10.2 to avoid CMP0048 policy warnings ---
cmake_minimum_required(VERSION 3.10.2)
project(puppy-ibvs)

# Set C++ standard to C++11 or higher
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Find required OpenCV and ROS Noetic packages   
find_package(OpenCV REQUIRED)
find_package(catkin REQUIRED 
    COMPONENTS
    roscpp
    cv_bridge
    std_msgs
    sensor_msgs
)

# Ensures the compiler knows where your header files reside.
include_directories(${catkin_INCLUDE_DIRS})

# Declare Catkin package build-time and runtime configs
catkin_package()

# Add libraries
add_library(robot-frame-proc include/robot-frame-proc.cpp)

# Link libraries with header files
target_include_directories(robot-frame-proc PUBLIC include)

# Add executable
add_executable(puppy-pov src/robot-view.cpp)

# Link dependencies to the application
target_link_libraries(puppy-pov 
  ${catkin_LIBRARIES}
  robot-frame-proc
)