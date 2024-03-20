#!/bin/bash

echo "Start installing the power management service..."

sudo cp -f ./x735-pwr.sh                /usr/local/bin/
sudo cp -f x735-pwr.service             /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x735-pwr
sudo systemctl start x735-pwr

echo "Power management service installed"