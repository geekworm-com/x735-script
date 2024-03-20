#!/bin/bash

# Uninstall xfan.service:
sudo systemctl stop x735-fan
sudo systemctl disable x735-fan
file_path="/lib/systemd/system/x735-fan.service"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

file_path="/usr/local/bin/x735-fan.sh"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

# Uninstall x735-pwr.service
sudo systemctl stop x735-pwr
sudo systemctl disable x735-pwr
file_path="/lib/systemd/system/x735-pwr.service"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

file_path="/usr/local/bin/x735-pwr.sh"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

file_path="/usr/local/bin/xgpio_pwr"

if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

# Remove the xoff allias on .bashrc file
sudo sed -i '/x735off/d' ~/.bashrc
source ~/.bashrc

file_path="/usr/local/bin/x735-softsd.sh"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi

file_path="/usr/local/bin/xgpio_soft"
if [ -f "$file_path" ]; then    
    sudo rm -f "$file_path"    
fi
