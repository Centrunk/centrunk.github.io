# Preparing your Pi or PC

## Install the operating system

=== "Raspberry Pi"

    Use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to flash your SD card.

    1. Choose the appropriate board.
    2. Select the Legacy 64-bit (normal or lite) version of Raspberry Pi OS. Click on "Raspberry Pi OS (other)" and scroll down.
    3. In the customizations, if applicable, input your wireless network settings.

=== "PC (Debian)"

    1. Ensure your PC has Linux Debian installed.

## Prepare the hardware

=== "Raspberry Pi"

    1. Before applying power to any parts, install the SMA 90-degree connector and attach the provided antennas to the hotspot. Once the antennas are successfully installed, place the hotspot onto the Pi GPIO pins found at the top of the board for flashing.  Alternatively, place the hotspot on the USB board and connect the USB port to your Pi.
    2. Connect the Raspberry Pi to power, and an internet connection through Ethernet or WiFi. If you configured a WiFi network during image setup, the Raspberry Pi should connect to your network automatically.

=== "PC (Debian)"

    1. You will need at least one USB conversion board for DVRS, or two for CC/VC operation.
    2. Before applying power to any parts, install the SMA 90-degree connector and attach the provided antennas to the hotspot. Once the antennas are successfully installed, place the hotspot onto the USB board and connect the USB port to your computer.
    3. Connect the computer to power, and an internet connection through Ethernet or WiFi.

## Software operations

=== "Raspberry Pi"
    ???+ info
        There is an automatic script to perform the steps below.  Once the script completes, your computer will reboot and you can proceed to the next section, [Flashing a hotspot](flashing-hotspot.md).
        ``` sh
        wget -qO- https://raw.githubusercontent.com/Centrunk/centrunk.github.io/main/script/prepare-pi.sh | sudo bash -
        ```

        !!! warning ""
            Executing scripts directly from the internet poses significant security risks. Always review the script's content before running it, especially when running it with elevated permissions like sudo.
            You can review the script by visiting the link of the script above.

    1.	Connect to your Pi and open a terminal window
        1.	If you are using a monitor and keyboard connected to the Raspberry Pi itself, open the terminal window and skip to Step 2.
        2.	If you are accessing the Raspberry Pi over your network, open a session in PuTTY or Windows PowerShell.
            1.	The syntax is ssh user@ipaddress, where user is the username specified in the image setup (default of pi) and ipaddress is the local IP address of the pi on your network.
            2.	You will be prompted to enter your password. Enter the password you specified in the image setup (default raspberry) and press Enter on your keyboard.

    2. Update the Pi and install needed utilities with the following commands:

        ``` sh
        sudo apt-get update && apt-get upgrade -y # (1)!
        ```

        1.  This updates your Pi to the latest software.  The command `-y`, in this context, enables to bypass the prompt asking you to confirm with `y` that you want to make the changes.

        ``` sh
        sudo apt-get install -y git stm32flash gcc-arm-none-eabi gcc g++ make build-essential libasio-dev libncurses-dev libssl-dev
        ```
    3. Open the `cmdline` config:

        ``` sh
        sudo nano /boot/firmware/cmdline.txt
        ```
    4. Remove `console=serial0,115200` at the start of the file, then press `Ctrl + S` to save and `Ctrl + X` to close.

    5. Open the startup config:

        ``` sh
        sudo nano /boot/firmware/config.txt
        ```

    6. Add `dtoverlay=disable-bt` to the `[all]` section of the file, then press `Ctrl + S` to save and `Ctrl + X` to close.

        !!! warning
            If you are using a Pi 3, add `dtoverlay=pi3-disable-bt` to the `[all]` section of the file instead.
    
    7. If on a Pi 5 using Bookworm or newer, add the following to the `[all]` section of the file:
        ```
        enable_uart=1
        dtoverlay=uart0,ctsrts
        ```

    8. Disable services that will interfere with the hotspots function with the following commands:

        ``` sh
        sudo systemctl disable serial-getty@ttyAMA0.service
        ```
        ``` sh
        sudo systemctl disable hciuart.service
        ```
        ``` sh
        sudo systemctl disable bluealsa.service
        ```
        ``` sh
        sudo systemctl disable bluetooth.service
        ```
        ``` sh
        sudo systemctl mask serial-getty@ttyAMA0.service
        ```
        ``` sh
        sudo systemctl mask hciuart.service
        ```
        ``` sh
        sudo systemctl mask bluealsa.service
        ```
        ``` sh
        sudo systemctl mask bluetooth.service
        ```

    9. Make directories to the Centrunk folder, navigate to it, then clone the firmware with the following commands:

        ``` sh
        sudo mkdir /opt/centrunk
        ```
        ``` sh
        cd /opt/centrunk
        ```
        !!! info

            The firmware varies whether you use a hotspot or a repeater board.
            === "Hotspots"

                ``` sh
                sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware-hs.git
                ```

            === "Repeater Boards"

                ``` sh
                sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware.git
                ```
    10.	Reboot the Raspberry Pi with the following command:

        ``` sh
        sudo reboot now
        ```

=== "PC (Debian)"

    1. Update the PC and install needed utilities with the following commands:

        ``` sh
        sudo apt-get update && apt-get upgrade -y # (1)!
        ```

        1.  This updates your PC to the latest software.  The command `-y`, in this context, enables to bypass the prompt asking you to confirm with `y` that you want to make the changes.

        ``` sh
        sudo apt-get install -y git stm32flash gcc-arm-none-eabi gcc g++ make build-essential libasio-dev libncurses-dev libssl-dev
        ```
    2. Make directories to the Centrunk folder, navigate to it, then clone the firmware with the following commands:

        ``` sh
        sudo mkdir /opt/centrunk && \
        cd /opt/centrunk
        ```
        !!! info

            The firmware varies whether you use a hotspot or a repeater board.
            === "Hotspots"

                ``` sh
                sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware-hs.git
                ```

            === "Repeater Boards"

                ``` sh
                sudo git clone --recurse-submodules https://github.com/DVMProject/dvmfirmware.git
                ```
