#! /bin/bash

rm -rf hdd
mkdir hdd
sudo losetup -o 2097152 /dev/loop16 hdd.raw
sudo mount /dev/loop16 hdd
