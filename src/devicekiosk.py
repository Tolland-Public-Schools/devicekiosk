import sys
import os
import datetime
import requests
import json
import smtplib
import yaml
import tempfile
import urllib.request
import shutil
import zipfile
import traceback
import subprocess
import uuid

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Signal, Slot, Qt, QRunnable, QThread, QThreadPool, QProcessEnvironment, QByteArray
from PySide6 import QtGui
from pathlib import Path
from enum import Enum
from email.message import EmailMessage

class KioskMode(Enum):
    normal = 0
    singleUser = 1
    eoyReturnOnly = 2

class ServiceMode(Enum):
    dropoff = 1
    pickup = 2
    dailyDevice = 3
    dailyCharger = 4

class UI(QObject):
    majorVersion = 1
    minorVersion = 0
    build = 1

    # Signals are special functions that allow a message to be sent from Python to QML UI
    # Instead of calling like a regular function, we call them as:
    # self.[signal].emit(argument)
    showDailyLoanersSignal = Signal(None)
    showUserSignal = Signal(None)
    showEmailScreenSignal = Signal(None)
    startOverSignal = Signal(None)
    showDescriptionSignal = Signal(None)
    showDeviceSignal = Signal(None)
    showPrintSignal = Signal(None)
    showDropoffSignal = Signal(None)
    enableNextSignal = Signal(None)
    showLoanerSignal = Signal(None)
    showSubmitSignal = Signal(None)
    showSubmitPickupSignal = Signal(None)
    showReturnSignal = Signal(None)
    showPickupSignal = Signal(None)
    showErrorSignal = Signal(str)
    showErrorPageSignal = Signal(None)
    showFinishSignal = Signal(None)
    showEOYReturnSignal = Signal(None)
    showEOYStartSignal = Signal(None)
    
    firstName = ""
    lastName = ""
    studentID = ""
    emailAddress = ""
    description = ""
    serialNumber = ""
    loanerSerialNumber = ""
    # studentDeviceBarcode = ""
    # loanerDeviceBarcode = ""
    serviceMode = ServiceMode.dropoff
    schoolLogo = ""
    errorMessage = ""
    config = None

    def loadConfig(self):
        path = os.path.dirname(os.path.abspath(__file__))
        configFile = os.path.join(path,'config.yml')
        self.config = yaml.safe_load(open(configFile))
        print("devicekiosk.py daily loaner status: " + str(self.config["show_daily_loaner"]))

    # def toEmail(self):
    #     print("loading new qml")
    #     path = os.path.dirname(os.path.abspath(__file__))
    #     qml = os.path.join(path,'qml','Email.qml')
    #     engine.load(qml)
    @Slot()
    def test(self):
        print("test")

    @Slot()
    def checkForErrors(self):
        self.showErrorSignal.emit(self.errorMessage)
    
    # @Slot()
    # def showEmailScreen(self):
    #     print("python showEmailScreen ran")
    #     self.showEmailScreenSignal.emit()

    @Slot(None, result=int)
    def getKioskMode(self):
        return self.config["kiosk_mode"]
    
    @Slot(None, result=str)
    def getEOYEmailAddresses(self):
        return self.config["eoy_return_addresses"]

    @Slot()
    def startOver(self):
        self.firstName = ""
        self.lastName = ""
        self.studentID = ""
        self.emailAddress = ""
        self.description = ""
        self.serialNumber = ""
        self.loanerSerialNumber = ""
        # self.studentDeviceBarcode = ""
        # self.loanerDeviceBarcode = ""
        self.serviceMode = ServiceMode.dropoff
        self.errorMessage = ""
        self.startOverSignal.emit()

    # @Slot('QString')
    # def submitEmail(self, address):
    #     self.emailAddress = address
    #     if (self.serviceMode == Mode.dropoff):
    #         self.showDescriptionSignal.emit()
    #     else:
    #         self.showDeviceSignal.emit()

    @Slot()
    def showHideDailyLoaners(self):
        if (self.config["show_daily_loaner"] == True):
            print("showing daily loaners")
            self.showDailyLoanersSignal.emit()
        else:
            print("keeping daily loaners hidden")

    @Slot(list)
    def submitUser(self, userInfo):
        print(userInfo)
        self.firstName = userInfo[0]        
        self.lastName = userInfo[1]        
        self.studentID = userInfo[2]
        # Strip spaces. Some users were putting spaces after their first and last name
        self.firstName = self.firstName.replace(" ", "")
        self.lastName = self.lastName.replace(" ", "")
        self.studentID = self.studentID.replace(" ", "")
        self.emailAddress = self.firstName + self.lastName + self.studentID + "@tolland.k12.ct.us"
        print("Student email is: " + self.emailAddress)
        if (self.serviceMode == ServiceMode.dropoff):
            self.showDescriptionSignal.emit()
        else:
            self.showReturnSignal.emit()
        
    @Slot('QString')
    def submitSerial(self, serial):
        self.serialNumber = serial
        self.serialNumber = self.serialNumber.replace(" ", "")      
        if (self.serviceMode == ServiceMode.dropoff):
            self.showPrintSignal.emit()
        else:
            self.showSubmitPickupSignal.emit()

    @Slot('int')
    def start(self, mode):
        self.serviceMode = ServiceMode(mode)
        print("Service mode: ")
        print(self.serviceMode)
        self.showUserSignal.emit()

    @Slot('QString')
    def submitDescription(self, description):
        self.description = description
        print("Problem Descritpion:")
        print(self.description)
        self.showDeviceSignal.emit()

    def loadSchoolLogo(self):
        path = os.path.dirname(os.path.abspath(__file__))
        logo = os.path.join(path,'images','schoollogo.txt')
        with open(logo, 'r') as file:
            self.schoolLogo = file.read()
    
    @Slot()
    def printTicket(self):
        date = datetime.datetime.now()
        ticket = self.schoolLogo + "\nEmail: " + self.emailAddress + "\nService Tag: " + self.serialNumber + "\nDate: " + date.strftime("%x") + "\nDescription: " + self.description
        ticket += "\n\n\n----- IT Use -----\n\n\nTicket Number: \n\n\n\n\n\nDate Completed:\n\n\n\n\n\nAdditional Information:"
        print(ticket)
        lpr =  subprocess.Popen("/usr/bin/lpr", stdin=subprocess.PIPE)
        lpr.communicate(bytes(ticket, 'utf-8'))
        self.enableNextSignal.emit()
        

    @Slot()
    def submitPrint(self):
        self.showDropoffSignal.emit()

    @Slot()
    def submitDropOff(self):
        self.showLoanerSignal.emit()

    @Slot('QString')
    def submitLoaner(self, serial):
        self.loanerSerialNumber = serial
        # Remove superflous spaces
        self.loanerSerialNumber = self.loanerSerialNumber.replace(" ", "")
        self.showSubmitSignal.emit()
    
    @Slot('QString')
    def submitReturn(self, serial):
        self.loanerSerialNumber = serial
        # Remove superflous spaces
        self.loanerSerialNumber = self.loanerSerialNumber.replace(" ", "")
        self.showPickupSignal.emit()

    # Submit the QML form from Submit.qml
    @Slot()
    def submitTicketPage(self):
        self.showFinishSignal.emit()

    # Submit the ticket to ZenDesk
    @Slot()
    def submitTicket(self):
        print("submitting ticket")
        self.postToZenDesk()
        if (not self.errorMessage == ""):
            return
        self.sendEmail()
        if (not self.errorMessage == ""):
            return
        self.enableNextSignal.emit()
    
    @Slot()
    def processPickup(self):
        self.sendEmail()
        self.enableNextSignal.emit()

    @Slot(list)
    def submitEOYReturn(self, returnInfo):
        returnSerial = returnInfo[0]
        chargerReturned = returnInfo[1]

        print("end of year submitted")
        self.addToReturnFile(returnSerial, chargerReturned)
        self.showEOYReturnSignal.emit()

    @Slot('QString')
    def submitEOYFinish(self, returnEmail):
        self.emailEOYReturnFiles(returnEmail)
        self.archiveReturns()
        self.showEOYStartSignal.emit()
        
    def postToZenDesk(self):
        self.errorMessage = ""
        # New ticket info
        subject = self.firstName + " " + self.lastName + " Student Device Issue"
        body = self.description + "\nLoaner ID: " + self.loanerSerialNumber
        # Package the data in a dictionary matching the expected JSON
        # "custom_fields": [{"id": 1500007314361, "value": "student_device"}]
        data = {'ticket': {'subject': subject, 'comment': {'body': body}, 'requester': {'name': self.firstName + " " + self.lastName, 'email': self.emailAddress}, 'custom_fields': [{'id': 1500007314361, 'value': 'student_device'},{'id': 1500007314401, 'value':'ths'},{'id': 1900003862405, 'value': self.serialNumber}]}}
        # Encode the data to create a JSON payload
        payload = json.dumps(data)
        # Set the request parameters
        url = "https://" + self.config["zendesk_domain"] + ".zendesk.com/api/v2/tickets.json"
        user = self.config["zendesk_user"]
        pwd = self.config["zendesk_token"]
        headers = {'content-type': 'application/json'}
        # Do the HTTP post request
        response = requests.post(url, data=payload, auth=(user, pwd), headers=headers)
        # Check for HTTP codes other than 201 (Created)
        if response.status_code != 201:
            self.errorMessage = response.status_code
            self.showErrorSignal.emit('Error: ' + str(response.status_code))
            self.showErrorPageSignal.emit()
            return
        # Report success
        print('Successfully created the ticket.')
        
    def sendEmail(self):
        msg = EmailMessage()        
        # me == the sender's email address
        # you == the recipient's email address
        if (self.serviceMode == ServiceMode.dropoff):
            msg['Subject'] = f'Student Device Drop Off: ' + self.firstName + ' ' + self.lastName
            body = self.firstName + " " + self.lastName + " has dropped off a laptop for repair.\nStudent Number: " + self.studentID + "\nDropped off student device serial number: " + self.serialNumber + "\nLoaner Serial Number: " + self.loanerSerialNumber
            msg.set_content(body)
        else:
            msg['Subject'] = f'Student Device Pick Up: ' + self.firstName + ' ' + self.lastName
            body = self.firstName + " " + self.lastName + " has picked up a repaired laptop.\nStudent Number: " + self.studentID + "\nReturned loaner serial number: " + self.loanerSerialNumber + "\nPicked up student device serial number: " + self.serialNumber
            msg.set_content(body)
        msg['From'] = self.config["smtp_user"]
        msg['To'] = self.config["email_list"]

        # Send the message via Gmail SMTP server
        s = smtplib.SMTP("smtp.gmail.com", 587)
        s.ehlo()
        s.starttls()
        s.login(self.config["smtp_user"], self.config["smtp_password"])
        try:
            s.send_message(msg)
        except smtplib.SMTPException as ex:
            self.errorMessage = ex
        s.close()

    def emailEOYReturnFiles(self, returnAddress):
        msg = EmailMessage()
        msg['Subject'] = 'EOY Return Files'
        body = "EOY Return Files"
        msg.set_content(body)
        attachmentFolder = os.path.dirname(os.path.abspath(__file__))
        # files = 
        for file in os.listdir(attachmentFolder):
            if file.endswith(".csv"):
                with open(os.path.join(attachmentFolder, file), 'rb') as content_file:
                    print(file)
                    content = content_file.read()
                    msg.add_attachment(content, maintype='application', subtype='txt', filename=str(file))
        # email.add_attachment(content, maintype='application', subtype='pdf', filename='example.pdf')
        msg['From'] = self.config["smtp_user"]
        msg['To'] = self.config["eoy_return_addresses"] + ", " + returnAddress
        # Send the message via Gmail SMTP server
        s = smtplib.SMTP("smtp.gmail.com", 587)
        s.ehlo()
        s.starttls()
        s.login(self.config["smtp_user"], self.config["smtp_password"])
        try:
            s.send_message(msg)
        except smtplib.SMTPException as ex:
            self.errorMessage = ex
            print("Email error " + ex)
        s.close()

    def addToReturnFile(self, serial, returnedCharger):
        print("Adding " + serial + " to return file, with charger: " + str(returnedCharger))
        filename = "eoy-returns-" + str(datetime.date.today()) + ".csv"
        returnsFile = os.path.join(os.path.dirname(os.path.abspath(__file__)),filename)
        if not os.path.exists(returnsFile):
            with open(returnsFile, 'a') as f:
                f.writelines("Serial, Charger\n")
                f.writelines(serial + "," + str(returnedCharger) + "\n")
                f.close()
        else: 
            # Populate version.txt with the newly installed build
            with open(returnsFile, 'a') as f:
                f.writelines(serial + "," + str(returnedCharger) + "\n")
                f.close()

    def archiveReturns(self):
        workingDir = os.path.dirname(os.path.abspath(__file__))
        archiveDir = os.path.join(workingDir, "return-archive", str(uuid.uuid4()))
        if not os.path.exists(archiveDir):
            os.makedirs(archiveDir)
        for file in os.listdir(workingDir):
            if file.endswith(".csv"):
                shutil.move(os.path.join(workingDir, file), archiveDir)

if __name__ == "__main__":
    QGuiApplication.setAttribute(Qt.AA_EnableHighDpiScaling, True) #enable highdpi scaling
    QGuiApplication.setAttribute(Qt.AA_UseHighDpiPixmaps, True) #use highdpi icons
    app = QGuiApplication(sys.argv)    
    # Instatitate objects
    ui = UI()
    ui.loadConfig()
    ui.loadSchoolLogo()
    
    engine = QQmlApplicationEngine()
    # Bind objects to the QML
    engine.rootContext().setContextProperty("ui",ui)
    engine.quit.connect(app.quit)    
    path = os.path.dirname(os.path.abspath(__file__))
    qml = os.path.join(path,'qml','Main.qml')
    
    icon = os.path.join(path, 'icon', 'devicekiosk.ico')
    app.setWindowIcon(QtGui.QIcon(icon))
    
    engine.load(qml)
    sys.exit(app.exec_())