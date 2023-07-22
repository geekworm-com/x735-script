# XScript
This is script installation tutorial for `X735 v2.5 & v3.0`, and This guideline is similar to [XScript](https://github.com/geekworm-com/xscript) only because the hardware uses a different GPIO.
***
The original pwm fan control script is from [pimlie/geekworm-x-c1](https://github.com/pimlie/geekworm-x-c1), **pimlie** implements the pwm fan shell script, which does not depend on third-party python libraries at all. Thanks to **pimlie**.

User Guide: https://wiki.geekworm.com/X735-script

## OS that has been tested
* Raspbian
* DietPi
* Manjaro
* Ubuntu
* myNode
* Umbrel
* Volumio
* RetroPie
* Twister

## Preconfigured `config.txt`
To install pwm fan, first add `dtoverlay=pwm-2chan,pin2=13,func2=4` to `/boot/config.txt` under `[all]`  or the end of file and `reboot`:
<pre>
sudo nano /boot/config.txt
</pre>
**Or**    (it's `/boot/firmware/config.txt` if you are using `ubuntu`)
<pre>
sudo nano /boot/firmware/config.txt
</pre>
Save & exit.
<pre>
sudo reboot
</pre>

## Clone the script
<pre>
git clone https://github.com/geekworm-com/x735-script

cd x735-script
chmod +x *.sh
</pre>

## Create the `x735-fan` service
<pre>
sudo cp -f ./x735-fan.sh                /usr/local/bin/
sudo cp -f ./x735-fan.service           /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x735-fan
sudo systemctl start x735-fan
</pre>
Then the pwm fan starts running

> PS: If your device does not support pwm fans or you are not using pwm, you can skip this step
>
## Create the `x735-pwr` service
<pre>
sudo cp -f ./x735-pwr.sh                /usr/local/bin/
sudo cp -f x735-pwr.service             /lib/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable x735-pwr
sudo systemctl start x735-pwr
</pre>

## Prepair software shutdown
<pre>
sudo cp -f ./x735-softsd.sh             /usr/local/bin/
</pre>
Create a alias `x735off` command to execute the software shutdown
<pre>
echo "alias x735off='sudo /usr/local/bin/x735-softsd.sh'" >>   ~/.bashrc
source ~/.bashrc
</pre>
Then you can run `x735off` to execute software safe shutdown.

## Test safe shutdown
Software safe shutdown command:
<pre>
x735off
</pre>

Hardware safe shutdown operation:
* press on-board button switch 1-2 seconds to reboot
* press button switch 3 seconds to safe shutdown,
* press 7-8 seconds to force shutdown.

## Other
`fan-rpi.py` and `fan-pigpio.py` are no longer used, and are reserved here for research and use by python lovers only.

Email: info@geekworm.com
