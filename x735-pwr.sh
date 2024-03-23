#!/bin/bash

SHUTDOWN=5
BOOT=12

PWMCHIP=0

REBOOTPULSEMINIMUM=200
REBOOTPULSEMAXIMUM=600

gpioset $PWMCHIP $BOOT=1

while [ 1 ]; do
  shutdownSignal=$(gpioget $PWMCHIP $SHUTDOWN)
  if [ $shutdownSignal = 0 ]; then
    /bin/sleep 0.2
  else
    pulseStart=$(date +%s%N | cut -b1-13)
    while [ $shutdownSignal = 1 ]; do
      /bin/sleep 0.02
      if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMAXIMUM ]; then
        echo "Your device are shutting down", SHUTDOWN, ", halting Rpi ..."
        sudo poweroff
        exit
      fi
      shutdownSignal=$(gpioget $PWMCHIP $SHUTDOWN)
    done
    if [ $(($(date +%s%N | cut -b1-13)-$pulseStart)) -gt $REBOOTPULSEMINIMUM ]; then
      echo "Your device are rebooting", SHUTDOWN, ", recycling Rpi ..."
      sudo reboot
      exit
    fi
  fi
done 
