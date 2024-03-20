#!/bin/bash

echo "Start installing fan service..."

sudo cp -f ./x735-fan.sh                /usr/local/bin/
sudo cp -f ./x735-fan.service           /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x735-fan
sudo systemctl start x735-fan

echo "Fan service installed"