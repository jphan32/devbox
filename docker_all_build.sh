#!/bin/sh
sudo docker build -t jphan32/devbox:base ./base
sudo docker build -t jphan32/devbox:runtime ./runtime
sudo docker build -t jphan32/devbox:v1.0.0 ./devel
exit 0