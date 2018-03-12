//
//  PeripheralBLEController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 10/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import UIKit
import CoreBluetooth

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//    switch (lhs, rhs) {
//    case let (l?, r?):
//        return l < r
//    case (nil, _?):
//        return true
//    default:
//        return false
//    }
//}

class PeripheralBLEController: NSObject, CBPeripheralManagerDelegate {
   
    private var peripheralManager: CBPeripheralManager?
    private var transferCharacteristic: CBMutableCharacteristic?
    
    private var dataToSend: Data?
    private var sendDataIndex: Int?
    
    // First up, check if we're meant to be sending an EOM
    private var sendingEOM = false
    
    private var recivedDataToSend: String?
    
    func startPeripheralManager() {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//        dataToSend = "MArko petko".data(using: String.Encoding.utf8)
//        print("Data to send: \(dataToSend?.count)")
    }
    
    // if view disapeared ot text changed
    func stopPeripheralAdvertising() {
        peripheralManager?.stopAdvertising()
    }
    
    func startAdvertising(send: Bool, dataToSend: String = String()) {
        if send {
            recivedDataToSend = dataToSend
            peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [transferServiceUUID]])
        } else {
            peripheralManager?.stopAdvertising()
        }
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .poweredOn:
            print("Peripheral state: BLE on!")
            
            // start with CBMutableCharacteristics
            transferCharacteristic = CBMutableCharacteristic(type: transferCharacteristicUUID, properties: .notify, value: nil, permissions: .readable)
            
            // start service
            let transferService = CBMutableService(type: transferServiceUUID, primary: true)
            
            // addd characteristics to service
            guard let characteristics = transferCharacteristic else { return }
            transferService.characteristics = [characteristics]
            
            // add to peripheral manager
            peripheralManager?.add(transferService)

        case .poweredOff:
            print("Peripheral state: BLE off!")
            
        case .resetting:
            print("Peripheral state: BLE resetting!")
            
        case .unauthorized:
            print("Peripheral state: BLE unauthorized!")
            
        case .unknown:
            print("Peripheral state: BLE unknown!")
            
        case .unsupported:
            print("Peripheral state: BLE unsupported!")
        }
    }
    
    // catch when someone subscribes to our characteristics then start sending
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
        
        // prepare data
//        dataToSend = "MArko petko".data(using: String.Encoding.utf8)
        guard let sendThisData = recivedDataToSend else { return }
        dataToSend = sendThisData.data(using: String.Encoding.utf8)      
        
        // reset index
        sendDataIndex = 0
        
        // start sending
        sendData()
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubcired from characteristic")
    }
    
    private func sendData() {
        // data finished to send, prepare last bit of data
        if sendingEOM {
            guard let didSend = peripheralManager?.updateValue("EOM".data(using: String.Encoding.utf8)!, for: transferCharacteristic!, onSubscribedCentrals: nil) else { return }
            
            // if send
            if didSend {
                print("Data sended!")
                sendingEOM = false
                
                // fisnish with sending
                startAdvertising(send: false)
            } else {
//                  It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
                return
            }
        }
        
        // if no data left to send
        guard  let countData = dataToSend?.count, let sendedIndex = sendDataIndex else { return }
        guard sendedIndex < countData else { return }
        
        // if data left, keep sending
        keepSendingData()
    }
    
    private func keepSendingData() {
        var didSend = true

        while didSend {
            // prepare next bit of data to send
            guard  let countData = dataToSend?.count, let sendedIndex = sendDataIndex else { return }

            var amountToSend = countData - sendedIndex
            
            // max data that can be send, atm 20 bytes
            if amountToSend > TOTAL_BYTES_LIMIT {
                amountToSend = TOTAL_BYTES_LIMIT
            }
            
            // chunk of data to send
            let chunk = dataToSend?.withUnsafeBytes{ (body: UnsafePointer<UInt8>) in
                return Data(bytes: body + sendedIndex, count: amountToSend)
            }
            
            // send
            didSend = (peripheralManager?.updateValue(chunk!, for: transferCharacteristic!, onSubscribedCentrals: nil))!
            
            // if error, drop out!
            if !didSend {
                return
            }
            
//            let stringFromData = NSString(data: chunk!, encoding: String.Encoding.utf8.rawValue)
//            print("Sended data: \(stringFromData)")

            // update index
            if sendDataIndex != nil {
                sendDataIndex! += amountToSend
            }
            
            checkIfLastChunkOfData()
        }
    }
    
    private func checkIfLastChunkOfData() {
        guard  let countData = dataToSend?.count, let sendedIndex = sendDataIndex else { return }
        
        if sendedIndex >= countData {
            
            // if last
            sendingEOM = true
            
            guard let eomSent = peripheralManager?.updateValue("EOM".data(using: String.Encoding.utf8)!, for: transferCharacteristic!, onSubscribedCentrals: nil) else { return }
            
            // sended
            if eomSent {
                sendingEOM = false
            }
            
            return
        }
    }
    
//    This callback comes in when the PeripheralManager is ready to send the next chunk of data.
//    This is to ensure that packets will arrive in the order they are sent
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        sendData()
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print("Did Start sending, error: \(String(describing: error))")
    }
    
}
















