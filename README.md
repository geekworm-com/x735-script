# x735-script

User Guide: https://wiki.geekworm.com/X735-script

Email: support@geekworm.com


# Update
Use gpiod instead of obsolete interface, and suuports ubuntu 23.04 also

NASPi series does not support Raspberry Pi 5 hardwared due to different hardware interface.

## Software shutdown service:

PWM_CHIP=0

BUTTON=20
> /usr/local/bin/xSoft.sh 0 20

## Power management service
PWMCHIP=0

SHUTDOWN=5

BOOT=12

>/usr/local/bin/xPWR.sh 0 5 12

## If working with Raspberry Pi 5 hardware, the following changes need to be made after cloning the file
```
sed -i 's/xSoft.sh 0 20/xSoft.sh 4 20/g' install-sss.sh
sed -i 's/xPWR.sh 0 5 12/xPWR.sh 4 5 12/g' x735-pwr.service
sed -i 's/pwmchip0/pwmchip2/g' x735-fan.sh
```
