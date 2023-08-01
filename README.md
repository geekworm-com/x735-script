# Overview
The "x735-script" is a Bash script designed to manage the x735 Power Management and Cooling Expansion Board (HAT) for Raspberry Pi 3 and 4. This script enables the user to control various features of the x735 board, including restarting or shutting down the Raspberry Pi using a physical button on the x735 board. Additionally, it uses the PWM pin to control the speed of the fan based on the CPU temperature, providing efficient cooling.

## Features
* Control over GPIO pins to activate the restart and shutdown button on the x735 board.
* Dynamic fan speed control based on the CPU temperature for optimal cooling.
* Automatic installation of the `x735off` command, enabling safe shutdown of the Raspberry Pi with the x735 HAT.
Installation
* Before installing the "x735-script," make sure you have the necessary tools and packages. The script requires the dpkg-deb package, which is commonly used for handling Debian packages.

### Installing dpkg-deb and Dependencies
If you don't have the `dpkg-deb` package and its dependencies installed, follow these steps:

1. Open a terminal on your Raspberry Pi.

2. Update the package list and install the required packages:

    ``` BASH
    sudo apt update && sudo apt install dpkg-dev -y
    ```

### Cloning the Repository and Building the Package
Now, let's proceed with installing the "x735-script" package:

1. Clone the Git repository containing the "x735-script" code and Change your current directory:

    ``` BASH
    git clone https://github.com/your-username/x735-script.git && cd x735-script
    ```

2. Build the Debian package using dpkg-deb:

    ``` BASH
    sudo dpkg-deb --build x735-script-pkg
    ```

3. Installing the Package

    Once the Debian package is built, you can install it using the following command:
    ``` BASH
    sudo dpkg -i x735-script-pkg.deb
    ```

## Verifying Package Content
You can verify the content and installation information of the "x735-script" package with the following command:

``` BASH
sudo dpkg -I x735-script-pkg.deb
```

## User Guide
For detailed instructions on how to use the "x735-script" and leverage its features, please refer to the official User Guide available at:

[https://wiki.geekworm.com/X735-script](https://wiki.geekworm.com/X735-script)

Contact
For any questions, issues, or support related to the "x735-script," you can reach out to the development team at:

Email: [support@geekworm.com](mailto:support@geekworm.com)

Thank you for using the "x735-script" to manage your x735 Power Management and Cooling Expansion Board. We hope this script enhances your Raspberry Pi experience and ensures smooth operations with improved cooling and power management capabilities. Should you need any assistance, feel free to contact our support team via email. Happy tinkering!