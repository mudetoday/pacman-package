#!/bin/bash

mkdir ~/Templates/PacmanPackage
cp -r ./* ~/Templates/PacmanPackage
cd ~/Templates/PacmanPackage
find . -name "*.sh" -not -name "rename-template.sh" -delete
