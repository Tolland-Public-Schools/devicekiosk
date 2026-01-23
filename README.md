# Device Kiosk
Device repair dropoff kiosk app written in Python and QML

Install pre-requisites:

pip install pyside6 pyinstaller pyyaml

run with:

python3 src/devicekiosk.py

package with:

buildlinuxbinaries.sh

or

buildwindowsbinaries.ps1

To use homeroom lookups via PowerSchool, install the PowerSchool Device Kiosk plugin from https://github.com/Tolland-Public-Schools/devicekiosk-powerschool-plugin

To debug in a Debian dev container, you'll need to run:
sudo apt install -y libgl1 libegl1