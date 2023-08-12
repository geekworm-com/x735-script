# Overview
The "x735-script" is a Bash script designed to manage the x735 Power Management and Cooling Expansion Board (HAT) for Raspberry Pi 3 and 4. This script enables the user to control various features of the x735 board, including restarting or shutting down the Raspberry Pi using a physical button on the x735 board. Additionally, it uses the PWM pin to control the speed of the fan based on the CPU temperature, providing efficient cooling.

## Features
Control over GPIO pins to activate the restart and shutdown button on the x735 board.
Dynamic fan speed control based on the CPU temperature for optimal cooling.
Automatic installation of the x735off command, enabling safe shutdown of the Raspberry Pi with the x735 HAT.

## Installation
Installing the `x735-script` is a straightforward process. To begin, simply click on the link below to access the latest release:

**[https://github.com/molhamalnasr/x735-script/releases/latest](https://github.com/molhamalnasr/x735-script/releases/latest)**

Once you're on the release page, follow the provided instructions to install the script on your Raspberry Pi. The installation process will guide you through the necessary steps to set up the fan speed control and power management features seamlessly.

If you prefer to install an older version of the script for compatibility or other reasons, you can do so by clicking on the link below:

**[https://github.com/molhamalnasr/x735-script/releases](https://github.com/molhamalnasr/x735-script/releases)**

## Developer's Guide
If you are a developer and want to contribute to the "x735-script" or perform further development, follow these steps:

- Install the necessary dependencies:
    ``` bash
    sudo apt-get update && sudo apt-get install -y dpkg
    ```

- Clone the repository and change to the project directory:
    ``` bash
    git clone https://github.com/molhamalnasr/x735-script && cd x735-script
    ```

- Grant necessary permissions:
    ``` bash
    chmod +x x735-script-pkg/usr/bin/x735off
    chmod +x x735-script-pkg/usr/lib/x735-script/scripts/*.sh
    find x735-script-pkg/DEBIAN -type f ! -name 'compat' -exec chmod +x {} \;
    ```

- Build and test the package:
    ``` bash
    dpkg-deb --build x735-script-pkg
    ```

You can verify the content and installation information of the "x735-script" package with the following command:

``` bash
sudo dpkg -I x735-script-pkg.deb
```

## Release Information for Developers
For developers, please note the following steps to set up the necessary configurations for automated releases:

1. Generate a "Personal Access Token" in your Github account settings with the required permissions. Make sure to grant the "repo" scope to enable access for repository-related actions and name it `CREATE_RELEASE_TOKEN`.
2. Add this generated token to the repository's variable settings as a "Repository secret" named `CREATE_RELEASE_TOKEN`.
3. you need another 2 variables as a "Repository variables"
    - USER_EMAIL="\<YOUR EMAIL\>"
    - USER_NAME=\<YOUR FULL NAME\>

These steps are essential for enabling the Github Actions workflow to create automated releases when you push a tag starting with the letter "v*" to the main branch. for example: v3.0.1. The "GITHUB_TOKEN" repository secret will be used by the workflow to build a new release and upload it as an artifact to Github. The release will be available under: https://github.com/molhamalnasr/x735-script/releases/latest. and the "USER_EMAIL" and "USER_NAME" are used to create/append the changelog file for the package.

By following these instructions, you ensure a streamlined process for managing releases and promoting collaboration among developers in the project.

## User Guide
For detailed instructions on how to use the "x735-script" and leverage its features, please refer to the official User Guide available at:

[https://wiki.geekworm.com/X735-script](https://wiki.geekworm.com/X735-script)

#### Contact
For any questions, issues, or support related to the "x735-script," you can reach out to the development team at:

Email: [support@geekworm.com](mailto:support@geekworm.com)

Thank you for using the "x735-script" to manage your x735 Power Management and Cooling Expansion Board. We hope this script enhances your Raspberry Pi experience and ensures smooth operations with improved cooling and power management capabilities. Should you need any assistance, feel free to contact our support team via email. Happy tinkering!