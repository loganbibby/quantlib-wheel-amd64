#!/usr/bin/env bash

ROOT_DIR=`cwd`

docker build -t quantlib-wheel .

docker run --rm -v $ROOT_DIR/drop:/drop -v $ROOT_DIR/root:/root_dir quantlib-wheel
