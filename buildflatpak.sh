#!/bin/bash

# Virtual Environment
echo "Creating a virtual environment"
python3 -m venv venv/
source venv/bin/activate

# Build
echo "Building Device Kiosk"

python3 -m pip install requirements-parser
python3 -m pip install -r requirements.txt
python3 -m pip install -e .
python3 -m pip install --upgrade build
python3 -m build

python3 venv/bin/flatpak_pip_generator requests
python3 venv/bin/flatpak_pip_generator EmailMessage
python3 venv/bin/flatpak_pip_generator pyyaml

# Flathub
echo "Adding the flathub repo"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing the KDE flatpak runtime and SDK"
#flatpak -y install org.kde.Platform/x86_64/5.15-23.08
sudo flatpak -y install org.kde.Platform/x86_64/6.9 org.kde.Sdk/x86_64/6.9

echo "Installing PySide6 Baseapp"
sudo flatpak -y install app/io.qt.PySide.BaseApp/x86_64/6.9

echo "Building Flatpak"
flatpak-builder --verbose --force-clean flatpak-build-dir us.ct.k12.tolland.devicekiosk.json --repo=repo

# To test the flatpak
# flatpak-builder --run flatpak-build-dir us.ct.k12.tolland.devicekiosk.json devicekiosk