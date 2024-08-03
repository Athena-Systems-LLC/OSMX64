#!/bin/bash

dirlist=$(find tb/ -type f -name "Makefile")

for dir in $dirlist
do
    make -C $(dirname $dir)
done
