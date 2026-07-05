#!/usr/bin/env bash
# Remove everything px4-ros2-setup.sh created: containers, images, sources.
set -uo pipefail

echo "=== Stopping stray sim processes"
for p in "ruby.*gz sim" "^/home/.*/bin/px4" "MicroXRCEAgent"; do
  pgrep -f "$p" | xargs -r kill 2>/dev/null
done

echo "=== Removing containers"
distrobox rm --force px4-ros2 px4-gui 2>/dev/null

echo "=== Removing images"
podman rmi ubuntu:22.04 ubuntu:24.04 2>/dev/null

echo "=== Removing sources and caches"
rm -rf ~/PX4-Autopilot ~/Micro-XRCE-DDS-Agent ~/.gz ~/.ros

echo "=== Done"
