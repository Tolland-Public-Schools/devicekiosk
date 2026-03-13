#!/bin/bash
# Virtual Environment
echo "Creating a virtual environment"
python3.9 -m venv venv/
source venv/bin/activate

# Build
echo "Building Device Kiosk"

python3 -m pip install requirements-parser pyinstaller
python3 -m pip install -r requirements.txt
python3 -m pip install -e .

pyinstaller -y src/devicekiosk.spec