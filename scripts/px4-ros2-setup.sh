#!/usr/bin/env bash
# PX4 + ROS 2 Humble + Gazebo Harmonic via distrobox on NixOS.
#
# Works on both hosts:
#   Non-NVIDIA (MovingCastle): single px4-ros2 container (Ubuntu 22.04); Mesa GL
#     works in-container via the normal /dev/dri passthrough, GUI runs locally.
#   NVIDIA (MinasTirith): driver 580 aborts in libnvidia-glcore against jammy's
#     old libxcb, so a second px4-gui container (Ubuntu 24.04) runs the Gazebo
#     GUI; a gz wrapper in px4-ros2 delegates `gz sim -g` via the host podman
#     socket. Same hostname => same gz-transport partition. Needs
#     hardware.nvidia-container-toolkit (CDI) on the host.
set -euo pipefail

NVIDIA=0
[ -f /var/run/cdi/nvidia-container-toolkit.json ] && NVIDIA=1
gpu_flag=()
[ "$NVIDIA" = 1 ] && gpu_flag=(--additional-flags "--device nvidia.com/gpu=all")
echo "NVIDIA host: $NVIDIA"

echo "=== [1/7] Create containers"
distrobox list | grep -q ' px4-ros2 ' \
  || distrobox create --name px4-ros2 --image ubuntu:22.04 "${gpu_flag[@]}" --yes
if [ "$NVIDIA" = 1 ]; then
  distrobox list | grep -q ' px4-gui ' \
    || distrobox create --name px4-gui --image ubuntu:24.04 "${gpu_flag[@]}" --yes
fi

echo "=== [2/7] Start clones + px4-gui provisioning in the background"
clone_all() {
  [ -d ~/PX4-Autopilot ] || git clone -q --recursive https://github.com/PX4/PX4-Autopilot.git ~/PX4-Autopilot
  [ -d ~/Micro-XRCE-DDS-Agent ] || git clone -q https://github.com/eProsima/Micro-XRCE-DDS-Agent.git ~/Micro-XRCE-DDS-Agent
}
clone_all > /tmp/px4-clones.log 2>&1 &
CLONES_PID=$!

GUI_PID=""
trap '[ -n "$GUI_PID" ] && kill "$GUI_PID" 2>/dev/null; kill "$CLONES_PID" 2>/dev/null; true' EXIT
if [ "$NVIDIA" = 1 ]; then
  distrobox enter px4-gui -- sudo bash -c '
    set -e
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq curl gnupg lsb-release
    curl -fsSL https://packages.osrfoundation.org/gazebo.gpg \
      -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable noble main" \
      > /etc/apt/sources.list.d/gazebo-stable.list
    apt-get update -qq
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq gz-harmonic libblas3 liblapack3
    ln -sf /run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
  ' > /tmp/px4-gui-setup.log 2>&1 &
  GUI_PID=$!
fi

echo "=== [3/7] px4-ros2: base packages + ROS 2 Humble"
distrobox enter px4-ros2 -- sudo bash -c '
  set -e
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    software-properties-common curl gnupg lsb-release git wget locales
  locale-gen en_US en_US.UTF-8
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
  add-apt-repository -y universe
  curl -fsSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" \
    > /etc/apt/sources.list.d/ros2.list
  apt-get update -qq
  DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    ros-humble-desktop ros-dev-tools python3-pip python3-colcon-common-extensions
'

echo "=== [4/7] Wait for clones"
wait "$CLONES_PID" || { echo "CLONES FAILED — see /tmp/px4-clones.log"; exit 1; }

echo "=== [5/7] px4-ros2: PX4 toolchain + gz-harmonic + builds"
distrobox enter px4-ros2 -- bash -c '
  set -e
  cd ~/PX4-Autopilot && DEBIAN_FRONTEND=noninteractive bash Tools/setup/ubuntu.sh --no-nuttx
  make px4_sitl

  cd ~/Micro-XRCE-DDS-Agent && mkdir -p build && cd build
  cmake -DCMAKE_BUILD_TYPE=Release .. && make -j"$(nproc)"
  sudo make install && sudo ldconfig /usr/local/lib/
'

if [ "$NVIDIA" = 1 ]; then
  echo "=== [6/7] NVIDIA: GL glue + GUI delegation"
  wait "$GUI_PID" || { echo "px4-gui SETUP FAILED — see /tmp/px4-gui-setup.log"; exit 1; }
  distrobox enter px4-ros2 -- bash -c '
    set -e
    # NVIDIA vendor configs live at NixOS paths the Ubuntu glvnd does not scan
    sudo ln -sf /run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
    sudo mkdir -p /usr/share/egl
    sudo ln -sfn /run/opengl-driver/share/egl/egl_external_platform.d /usr/share/egl/egl_external_platform.d
    sudo ln -sf /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json

    sudo tee /usr/local/bin/gz >/dev/null <<"WRAP"
#!/bin/bash
# NVIDIA GL is broken in this jammy container (driver 580 vs old libxcb):
# GUI windows abort in libnvidia-glcore. Run the GUI in the px4-gui (noble)
# box instead, via the host podman socket. Containers share the host PID
# namespace, so the stale-GUI pkill must be anchored to not kill ourselves.
for a in "$@"; do
  if [ "$a" = "-g" ]; then
    PODMAN=""
    for p in /run/host/run/current-system/sw/bin/podman /run/host/usr/bin/podman; do
      [ -x "$p" ] && PODMAN=$p && break
    done
    [ -n "$PODMAN" ] || PODMAN=$(command -v podman) || { echo "gz wrapper: no podman found" >&2; exit 1; }
    SOCK="unix://${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    "$PODMAN" --url "$SOCK" start px4-gui >/dev/null 2>&1
    "$PODMAN" --url "$SOCK" exec --user "$(id -un)" px4-gui pkill -f "^gz sim -g" >/dev/null 2>&1
    exec "$PODMAN" --url "$SOCK" exec --user "$(id -un)" -e DISPLAY=:0 -e "HOME=$HOME" px4-gui gz "$@"
  fi
done
exec /usr/bin/gz "$@"
WRAP
    sudo chmod +x /usr/local/bin/gz
  '
else
  echo "=== [6/7] Non-NVIDIA host: Mesa GL works in-container, no GUI delegation needed"
fi

echo "=== [7/7] Smoke test: SITL boots, gz bridge connects"
distrobox enter px4-ros2 -- bash -c '
  cd ~/PX4-Autopilot
  HEADLESS=1 timeout 90 make px4_sitl gz_x500 </dev/null >/tmp/px4-smoke.log 2>&1 || true
  grep -aq "Startup script returned successfully" /tmp/px4-smoke.log \
    && echo "SMOKE OK" || { echo "SMOKE FAILED — see /tmp/px4-smoke.log"; exit 1; }
  pkill -f "ruby.*gz [s]im" 2>/dev/null; pkill -x px4 2>/dev/null; true
'

cat <<'USAGE'
Done. Usage:
  distrobox enter px4-ros2
    make -C ~/PX4-Autopilot px4_sitl gz_x500   # sim + GUI
    MicroXRCEAgent udp4 -p 8888                # DDS bridge (2nd terminal)
    source /opt/ros/humble/setup.bash          # then source your own workspace
    ros2 topic list                            # /fmu/* topics (3rd terminal)
USAGE
