#!/usr/bin/env bash
nix store optimise
nh clean all
sudo mount -o remount,rw /nix/store
echo 'defrag /nix'
sudo btrfs filesystem defragment -r -czstd /nix/
echo 'defrag /home'
sudo btrfs filesystem defragment -r -czstd /home/
echo 'defrag /'
sudo btrfs filesystem defragment -r -czstd /
echo 'cleanning done'

