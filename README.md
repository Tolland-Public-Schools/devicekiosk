# Device Kiosk
Device repair dropoff kiosk app written in Python and QML

Install pre-requisites:

Qt 6.2.4 from https://www.qt.io/download-qt-installer

pip install PySide6 pyinstaller pyyaml

run with:

python3 src/devicekiosk.py

package with:

buildlinuxbinaries.sh

or

buildwindowsbinaries.ps1

You must also have a file called config.yml in the same folder as the devicekiosk binary with the following format:

    zendesk_domain: your zendesk domain
    zendesk_user: dendesk token user
    zendesk_token: zendesk token
    smtp_user: valid smtp user email address
    smtp_password: smtp user password
    email_list: email address for repair notifications
    # Kiosk modes:
    # 0 = normal mode
    # 1 = single user dropoff/return mode: tickets are all assigned to the same user
    # 2 = end of year return-only mode
    kiosk_mode: 0
    # Addresses that receive all EOY device return CSV files
    eoy_return_addresses: EOY email addresses
    # Show daily loaner:true will add buttons on the start screen for daily device and charger borrowing
    show_daily_loaner: true
    # Email address that daily borrow/return notifications will be sent to
    daily_email_list: daily borrowed device email address
    email_daily_report: false
    print_daily_report: true
    single_user_email_address: email address to own ZenDesk ticket when kiosk in single user mode
    school_abbreviation: abbreviation to use in ZenDesk for school dropdown