#!/usr/bin/env bash
nix store optimise
nh clean all
sudo mount -o remount,rw /nix/store
sudo btrfs filesystem defragment -r -czstd /nix/
sudo btrfs filesystem defragment -r -czstd /home/
sudo btrfs filesystem defragment -r -czstd /

