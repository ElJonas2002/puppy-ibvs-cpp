#include <opencv2/opencv.hpp>
#include <ros/ros.h>
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/CompressedImage.h>

void imageCallback(const sensor_msgs::CompressedImageConstPtr& msg){

    try{
        // Convert ROS image message to an OpenCV matrix image
        cv::Mat frame = cv_bridge::toCvCopy(msg, "bgr8")->image;
        cv::imshow("PuppyPi POV", frame);
        
        if (cv::waitKey(1)==27){
            ros::shutdown();
        };
    }
    catch (cv_bridge::Exception& e){
        ROS_ERROR("cv_bridge exception: %s", e.what());
    }
}

int main(int argc, char **argv){
    // Initialize node
    ros::init(argc, argv, "puppy_pov");

    // Initialize node handler to interface with node process
    ros::NodeHandle nh;

    // Subscribe node to image transport topic
    ros::Subscriber img_sub = nh.subscribe("usb_cam/image_raw/compressed", 1, imageCallback);

    ros::spin();

    cv::destroyAllWindows();
    return 0;
}