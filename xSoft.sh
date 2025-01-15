#!/bin/bash

#  Use gpiod instead of obsolete interface, and suuports ubuntu 23.04 also

# Check if enough command line arguments were provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <gpio_chip> <button_pin>" >&2
    exit 1
fi

GPIOCHIP=$1
BUTTON=$2

SLEEP=4

# Checks if the passed parameter is an integer

re='^[0-9\.]+$'
if ! [[ $GPIOCHIP =~ $re ]] ; then
   echo "error: gpio_chip is not a number" >&2; exit 1
fi

if ! [[ $BUTTON =~ $re ]] ; then
   echo "error: button_pin is not a number" >&2; exit 1
fi

echo "Your device will be shutting down in $SLEEP seconds..."

gpioset $GPIOCHIP $BUTTON=1

sleep $SLEEP

# Restore GPIO
# This step is necessary, otherwise you will have to press the onboard button twice to turn on the device, and the same applies to the AUTO ON function.
gpioset $GPIOCHIP $BUTTON=0
