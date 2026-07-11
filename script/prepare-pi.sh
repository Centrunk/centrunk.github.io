#!/bin/bash

# Updating and installing utilities
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y git stm32flash gcc-arm-none-eabi gcc g++ make cmake build-essential libasio-dev libncurses-dev libssl-dev

# Removing a console configuration from /boot/cmdline.txt
sudo sed -i 's/console=serial0,115200 //g' /boot/firmware/cmdline.txt

# Determining the model of Raspberry Pi to adjust /boot/config.txt accordingly
model=$(tr -d '\0' < /proc/device-tree/model)
overlay="dtoverlay=disable-bt"
if echo "$model" | grep -q "Raspberry Pi 3"; then
    overlay="dtoverlay=pi3-disable-bt"
fi

# Adding the correct overlay to /boot/config.txt
echo "$overlay" | sudo tee -a /boot/firmware/config.txt

# Prompt user to select device type
read -p "Install for hotspots (h) or repeater boards (r)? " choice < /dev/tty
if [ "$choice" = "h" ]; then
    sudo mkdir -p /opt/centrunk
    sudo mkdir -p /var/logs/centrunk
    cd /opt/centrunk
    sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware-hs.git
elif [ "$choice" = "r" ]; then
    sudo mkdir -p /opt/centrunk
    sudo mkdir -p /var/logs/centrunk
    cd /opt/centrunk
    sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware.git
else
    echo "Invalid selection. Exiting."
    exit 1
fi

# Disabling services
sudo systemctl disable hciuart.service
sudo systemctl disable bluealsa.service
sudo systemctl disable bluetooth.service
sudo systemctl disable serial-getty@ttyAMA0.service
sudo systemctl mask serial-getty@ttyAMA0.service
sudo systemctl mask hciuart.service
sudo systemctl mask bluealsa.service
sudo systemctl mask bluetooth.service

# Rebooting
echo "The system will now reboot."
sudo reboot now
