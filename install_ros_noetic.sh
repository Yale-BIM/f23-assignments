# get ros ppa
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt install curl
# get updated keys based on https://answers.ros.org/question/325039/apt-update-fails-cannot-install-pkgs-key-not-working/
sudo -E apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update

# install ros
sudo apt install ros-noetic-desktop-full

# specific dependencies for these assignments
sudo apt install libnlopt-cxx0
sudo apt install ros-noetic-turtle-tf2 
sudo apt install ros-noetic-cv-bridge python3-cv-bridge
sudo apt install python3-vcstool
sudo apt install python-is-python3
sudo apt install python3-tk 
sudo apt install ros-noetic-pr2-description ros-noetic-ruckig 

# setup your environment so that you can find ros commands
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

# install extra deps
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential 
sudo rosdep init
rosdep update

# install extra software needed for shutter
sudo apt install python3-pip

# install wxPython for the arbotix-gui. Typically, you can do `pip install --user wxPython` but this takes a while to compile
pip install -U -f https://extras.wxpython.org/wxPython4/extras/linux/gtk3/ubuntu-20.04 wxPython

# install pip deps
pip install --upgrade --user pip  # upgrade pip
pip install --user gdown          # install library to download Shutter simulation
