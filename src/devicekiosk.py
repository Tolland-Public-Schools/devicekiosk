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

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Signal, Slot, Qt, QRunnable, QThread, QThreadPool, QProcessEnvironment, QByteArray
from PySide6 import QtGui
from pathlib import Path
from enum import Enum
from email.message import EmailMessage

class Mode(Enum):
    dropoff = 1
    pickup = 2

class UI(QObject):
    majorVersion = 1
    minorVersion = 0
    build = 1

    # Signals are special functions that allow a message to be sent from Python to QML UI
    # Instead of calling like a regular function, we call them as:
    # self.[signal].emit(argument)
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
    showReturnSignal = Signal(None)
    showErrorSignal = Signal(str)
    showErrorPageSignal = Signal(None)
    showFinishSignal = Signal(None)
    
    firstName = ""
    lastName = ""
    studentID = ""
    emailAddress = ""
    description = ""
    serialNumber = ""
    loanerSerialNumber = ""
    studentDeviceBarcode = ""
    loanerDeviceBarcrod = ""
    serviceMode = Mode.dropoff
    schoolLogo = ""
    errorMessage = ""
    config = None

    def loadConfig(self):
        path = os.path.dirname(os.path.abspath(__file__))
        configFile = os.path.join(path,'config.yml')
        self.config = yaml.safe_load(open(configFile))

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

    @Slot()
    def startOver(self):
        self.firstName = ""
        self.lastName = ""
        self.studentID = ""
        self.emailAddress = ""
        self.description = ""
        self.serialNumber = ""
        self.loanerSerialNumber = ""
        self.studentDeviceBarcode = ""
        self.loanerDeviceBarcrod = ""
        self.serviceMode = Mode.dropoff
        self.errorMessage = ""
        self.startOverSignal.emit()

    # @Slot('QString')
    # def submitEmail(self, address):
    #     self.emailAddress = address
    #     if (self.serviceMode == Mode.dropoff):
    #         self.showDescriptionSignal.emit()
    #     else:
    #         self.showDeviceSignal.emit()

    @Slot(list)
    def submitUser(self, userInfo):
        print(userInfo)
        self.firstName = userInfo[0]
        self.lastName = userInfo[1]
        self.studentID = userInfo[2]
        self.emailAddress = self.firstName + self.lastName + self.studentID + "@tolland.k12.ct.us"
        print("Student email is: " + self.emailAddress)
        if (self.serviceMode == Mode.dropoff):
            self.showDescriptionSignal.emit()
        else:
            self.showDeviceSignal.emit()
        
    @Slot('QString')
    def submitSerial(self, serial):
        self.serialNumber = serial        
        if (self.serviceMode == Mode.dropoff):
            self.showPrintSignal.emit()
        # else:
        #     self.printTicket()

    @Slot('int')
    def start(self, mode):
        self.serviceMode = Mode(mode)
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
        # TODO: Enable the following to actually print again
        # lpr =  subprocess.Popen("/usr/bin/lpr", stdin=subprocess.PIPE)
        # lpr.communicate(bytes(ticket, 'utf-8'))
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
        if (self.serviceMode == Mode.dropoff):
            self.showSubmitSignal.emit()
        else:
            self.showReturnSignal.emit()

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
            self.showErrorSignal.emit('Error: ' + response.status_code)
            self.showErrorPageSignal.emit()
            return
        # Report success
        print('Successfully created the ticket.')
        

    def sendEmail(self):
        msg = EmailMessage()        
        # me == the sender's email address
        # you == the recipient's email address
        if (self.serviceMode == Mode.dropoff):
            msg['Subject'] = f'Student Device Drop Off: ' + self.firstName + ' ' + self.lastName
            body = self.firstName + " " + self.lastName + " has dropped off a laptop for repair.\nStudent Number: " + self.studentID + "\nStudent Device Serial Number: " + self.serialNumber + "\nLoaner Serial Number: " + self.loanerSerialNumber
            msg.set_content(body)
        else:
            msg['Subject'] = f'Student Device Pick Up: ' + self.firstName + ' ' + self.lastName
            body = self.firstName + " " + self.lastName + " has picked up a repaired laptop.\nStudent Number: " + self.studentID + "\nStudent Device Serial Number: " + self.serialNumber + "\nLoaner Serial Number: " + self.loanerSerialNumber
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