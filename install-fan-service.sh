#!/bin/bash

echo "Start installing fan service..."

#Change the PWM_CHIP_PATH to /sys/class/pwm/pwmchip2 on line 7 of x735fan.sh if you use it on Raspberry Pi 5 hardware.
sudo cp -f ./x735-fan.sh                /usr/local/bin/
sudo cp -f ./pwm_fan_control.py         /usr/local/bin/
sudo cp -f ./x735-fan.service           /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x735-fan
sudo systemctl start x735-fan

echo "Fan service installed"
