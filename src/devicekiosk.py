import sys
import os
import datetime
import requests
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
    

    emailAddress = ""
    description = ""
    serialNumber = ""
    studentDeviceBarcode = ""
    loanerDeviceBarcrod = ""
    serviceMode = Mode.dropoff
    schoolLogo = ""
    

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
            self.printTicket()
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
    
    def printTicket(self):
        self.showPrintSignal.emit()
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
    def submitDropOff(self):
        self.showDropoffSignal.emit()
        

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