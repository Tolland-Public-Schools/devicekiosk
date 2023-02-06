import sys
import os
import datetime
import requests
import json
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
    

    emailAddress = ""
    description = ""
    serialNumber = ""
    loanerSerialNumber = ""
    studentDeviceBarcode = ""
    loanerDeviceBarcrod = ""
    serviceMode = Mode.dropoff
    schoolLogo = ""
    zenDeskAPIToken = ""
    

    print(serviceMode)

    # def toEmail(self):
    #     print("loading new qml")
    #     path = os.path.dirname(os.path.abspath(__file__))
    #     qml = os.path.join(path,'qml','Email.qml')
    #     engine.load(qml)
    @Slot()
    def test(self):
        print("test")
    
    # @Slot()
    # def showEmailScreen(self):
    #     print("python showEmailScreen ran")
    #     self.showEmailScreenSignal.emit()

    @Slot()
    def startOver(self):
        self.startOverSignal.emit()

    @Slot('QString')
    def submitEmail(self, address):
        self.emailAddress = address
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
        self.showEmailScreenSignal.emit()

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
        self.loadSchoolLogo()
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
        self.showSubmitSignal.emit()

    @Slot('QString')
    def submitLoaner(self, serial):
        self.loanerSerialNumber = serial
        if (self.serviceMode == Mode.dropoff):
            self.showSubmitSignal.emit()
        else:
            self.showReturnSignal.emit()

    @Slot()
    def submitTicket(self):
        print("submitting ticket")
        path = os.path.dirname(os.path.abspath(__file__))
        tokenPath = os.path.join(path,'apitoken.txt')
        if (not os.path.exists(tokenPath)):
            self.showErrorSignal.emit(tokenPath + " does not exist.")
            return
        with open(tokenPath, 'r') as file:
            self.zenDeskAPIToken = file.read()
        
        
    def postToZenDesk(self):
        # New ticket info
        subject = 'My printer is on fire!'
        body = self.description
        requester = ""
        # Package the data in a dictionary matching the expected JSON
        # "requester": { "locale_id": 8, "name": "Pablo", "email": "pablito@example.org" }
        data = {'ticket': {'subject': subject, 'comment': {'body': body}}}
        # Encode the data to create a JSON payload
        payload = json.dumps(data)
        # Set the request parameters
        url = 'https://tollandpublicschools.zendesk.com/api/v2/tickets.json'
        user = 'asher@tolland.k12.ct.us/token'
        pwd = self.zenDeskAPIToken
        headers = {'content-type': 'application/json'}
        # Do the HTTP post request
        response = requests.post(url, data=payload, auth=(user, pwd), headers=headers)
        # Check for HTTP codes other than 201 (Created)
        if response.status_code != 201:
            self.showErrorSignal.emit('Error: ' + response.status_code)
            return
        # Report success
        print('Successfully created the ticket.')
                

if __name__ == "__main__":
    QGuiApplication.setAttribute(Qt.AA_EnableHighDpiScaling, True) #enable highdpi scaling
    QGuiApplication.setAttribute(Qt.AA_UseHighDpiPixmaps, True) #use highdpi icons
    app = QGuiApplication(sys.argv)    
    # Instatitate objects
    ui = UI()
    
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