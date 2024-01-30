#!/bin/bash

# Virtual Environment
echo "Creating a virtual environment"
python3 -m venv --system-site-packages env/
source env/bin/activate

# Build
echo "Building Device Kiosk"

python3 -m pip install -e .
python3 -m pip install --upgrade build
python3 -m build

python3 flatpak-pip-generator requests
python3 flatpak-pip-generator EmailMessage
python3 flatpak-pip-generator pyyaml

# Flathub
echo "Adding the flathub repo"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing the KDE flatpak runtime and SDK"
#flatpak -y install org.kde.Platform/x86_64/5.15-23.08
flatpak -y install org.kde.Platform/x86_64/6.6 org.kde.Sdk/x86_64/6.6

echo "Installing PyQt Baseapp"
flatpak -y install app/com.riverbankcomputing.PyQt.BaseApp/x86_64/6.6

echo "Building Flatpak"
flatpak-builder --verbose --force-clean flatpak-build-dir us.ct.k12.tolland.devicekiosk.json --repo=repo

# To test the flatpak
# flatpak-builder --run flatpak-build-dir us.ct.k12.tolland.devicekiosk.json devicekiosk