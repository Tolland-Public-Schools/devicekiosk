# Device Kiosk
Device repair dropoff kiosk app written in Python and QML

Install pre-requisites:

pip install -r requirements.txt

run with:

python3 src/devicekiosk.py

package with:

buildlinuxbinaries.sh

or

buildwindowsbinaries.ps1

To use homeroom lookups via PowerSchool, install the PowerSchool Device Kiosk plugin from https://github.com/Tolland-Public-Schools/devicekiosk-powerschool-plugin

To debug in a Debian dev container, you'll need to run:
sudo apt install -y    
sudo apt-get update
    libdbus-1-3 
    libgl1 \
    libegl1 \
    libx11-xcb1 \
    libxkbcommon0 \
    libxkbcommon-x11-0 \
    libxcb1 \
    libxcb-render0 \
    libxcb-shape0 \
    libxcb-shm0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xfixes0 \
    libxcb-xinerama0 \
    libxcb-xinput0 \
    libxcb-cursor0
