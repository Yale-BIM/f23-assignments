# Azure Kinect Usage Notes

The [Azure Kinect](https://azure.microsoft.com/en-us/products/kinect-dk/) is a sensor manufactured by Microsoft that provides depth perception, body tracking and a microphone array.
A Kinect sensor is often positioned near Shutter to give a third-person perspective of the robot's environment.


## Installation

The [Azure Kinect SDK](https://github.com/microsoft/Azure-Kinect-Sensor-SDK) is installed via `apt-get` on the course laptops.
The following packages and their dependencies are necessary:
+ `k4a-tools`
+ `libk4a1.4-dev`
+ `libk4abt1.1-dev`

You can verify that the packages are installed with the command and expected output:
```
$ apt search <package name>
Sorting... Done
Full Text Search... Done
<package name>/bionic,now <version installed> amd64 [installed]
  <package description>
```
Note that a CUDA-enabled GPU is necessary to install the body tracking SDK.


### Diagnostic Tools

The Azure Kinect SDK and Body Tracking SDK installations can be verified with installed executables `k4aviewer` and `k4abt_simple_3d_viewer`:
1. First, ensure the Kinect sensor is connected to power and to the machine. It is recommended that the Kinect is connected directly to the machine, and not through a USB hub.
2. Launch `k4aviewer` from a terminal.
3. Follow the steps in [Azure Kinect Viewer guide](https://learn.microsoft.com/en-us/azure/kinect-dk/azure-kinect-viewer).
4. For the firmware versions, look for:
    + RGB Camera: 1.6.110
    + Depth Camera: 1.6.80
    + Audio: 1.6.14
5. Quit `k4aviewer`.
6. Launch `k4abt_simple_3d_viewer` from a terminal.
7. Verify that the point cloud and body tracking data are visible as seen in the [body tracking SDK setup guide](https://learn.microsoft.com/en-us/azure/kinect-dk/body-sdk-setup#verify-body-tracking)
8. If the body tracking fails to start, or shows high latency, the CUDA installation is likely misconfigured.

Any problems with the above steps should be communicated to course staff via Slack.


### Driver Installation

The [Azure Kinect ROS Driver](https://github.com/microsoft/Azure_Kinect_ROS_Driver) must be installed manually in your catkin workspace.
The following commands will install the driver in a new workspace:
```
$ mkdir -pv ~/catkin_ws/src
$ cd ~/catkin_ws/src
$ git clone https://github.com/microsoft/Azure_Kinect_ROS_Driver.git
$ cd ~/catkin_ws
$ catkin_make -DCMAKE_BUILD_TYPE=Release
```

## Usage

After building the ROS driver, you can start the Kinect with the following roslaunch command:
```
$ source devel/setup.bash
$ roslaunch azure_kinect_ros_driver driver.launch depth_mode:=WFOV_2X2BINNED body_tracking_enabled:=true
```
You can then visualize the following topics in RViz:
+ `/rgb/image_raw`
+ `/depth/image_raw`
+ `/body_tracking_data`

The launch file arguments are enumerated in the [Azure Kinect ROS Driver usage document](https://github.com/microsoft/Azure_Kinect_ROS_Driver/blob/melodic/docs/usage.md#parameters)


## Body Tracking Notes

The mappings for the joints output by the body tracking SDK are enumerated in the [Microsoft Kinect documentation](https://learn.microsoft.com/en-us/azure/kinect-dk/body-joints).

Joints are published as a `visualization_msgs/MarkerArray` message on the topic `/body_tracking_data`.
Note that the `MarkerArray` message is a flat array (list) of 32 x *n* markers, where *n* is the number of people detected by the sensor.
There are two important fields within each marker:

1. The `marker.id` which contains the tracked body ID and the joint index.
   The marker ID is calculated by the formula: `body_id * 100 + joint_index`.
   Hence, to derive the body ID, use `math.floor(marker.id / 100)`, and to derive the joint index, use `marker.id % 100`.

1. The `marker.pose` which contains the position (XYZ vector) and orientation (XYZW quaternion) of the marker.
   Note that the pose by default is expressed in the `depth_camera_link` coordinate frame.

The depth mode should be set to `NFOV_UNBINNED` or `WFOV_2X2BINNED` for the best joint inference.

In order to reason about the body tracking data relative to the robot, you will need to add the Kinect sensor to the robot's `tf` tree.
Because the Kinect does not move with the robot, you can broadcast a static transform (see [writing a tf2 static broadcaster](http://wiki.ros.org/tf2/Tutorials/Writing%20a%20tf2%20static%20broadcaster%20%28Python%29)).
Consult the course materials or course staff if you are uncertain how to add the Kinect to the `tf` tree.

> **Hint:** You can sketch the transform by measuring the XYZ displacement of the Kinect sensor from the robot base.
If you keep the Kinect orientation aligned with the robot base orientation, you can also sketch the rotation with simple increments of `PI/2` on the required axes.


## Troubleshooting Steps
The Kinect sensor requires a USB3.0 connection.
It is recommended to connect the Kinect directly to your machine, rather than through a USB hub.
Checking the sensor-side USB connection can also help to resolve errors when starting the Kinect.

If enabling body tracking, make sure that the `depth_mode` launch argument is set to `NFOV_UNBINNED` or `WFOV_2X2BINNED`.

The following external references are also helpful:
+ [Azure Kinect hardware specifications | What Does the Light Mean?](https://learn.microsoft.com/en-us/azure/kinect-dk/hardware-specification#what-does-the-light-mean): dictionary for the status LED located on the rear panel of the Kinect.
+ [GitHub Issues | find_dependency(k4a) version format mismatch](https://github.com/microsoft/Azure_Kinect_ROS_Driver/issues/143): a common error when building with `catkin_make`. Requires a CMake configuration edit (contact course staff).
+ [GitHub Issues | Support the Microphone Array](https://github.com/microsoft/Azure_Kinect_ROS_Driver/issues/120): the microphone array is not accessible through the Azure Kinect ROS driver. This GitHub Issue details some alternatives and workarounds for using the microphones.