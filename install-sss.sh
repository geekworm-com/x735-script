#!/bin/bash

# Install soft shutdown script (sss)
echo "Start installing the soft shutdown script (sss)..."

sudo cp -f ./x735-softsd.sh                /usr/local/bin/

echo "Create a alias 'x735off' command to execute the software shutdown"
echo "alias x735off='sudo /usr/local/bin/x735-softsd.sh'" >>   ~/.bashrc
source ~/.bashrc

echo "Soft shutdown script (sss) installed"