//
//  CentralBLEController.swift
//  TrainingBluetooth
//
//  Created by Ivica Petrsoric on 09/03/2018.
//  Copyright © 2018 Ivica Petrsoric. All rights reserved.
//

import CoreBluetooth

protocol CentralBLEControllerDelegate: class {
    func recivedDataFromPheriperal()
}


class CentralBLEController: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    weak var delegate: CentralViewController?
    
    private var centralManager: CBCentralManager?
    private var discoveredPheriperal: CBPeripheral?
    
    private var recivedData = NSMutableData()
    private var topRSSI = -35
    
    func startCentralManager(){
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopScanCentralManager() {
        print("Stop sccan")
        centralManager?.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            scan()
            
        case .poweredOff:
            print("Central state: BLE off!")
            
        case .resetting:
            print("Central state: BLE resetting!")
            
        case .unauthorized:
            print("Central state: BLE unauthorized!")
            
        case .unknown:
            print("Central state: BLE unknown!")
            
        case .unsupported:
            print("Central state: BLE unsupported!")
        }
    }
    
    private func scan() {
        print("Start scaning")
        centralManager?.scanForPeripherals(withServices: [transferServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: true)])
    }
    
    // check if pheriperal is dicovered, check if RSSI is strong to start DL
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "") at \(RSSI)")
        
        if RSSI.intValue > topRSSI{
            print("Device not at correct range")
            return
        }
        
        // it is in range
        if discoveredPheriperal != peripheral {
            print("Connecting to peripheral \(peripheral)")

            discoveredPheriperal = peripheral
            
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    // connection failed
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connecto to \(peripheral), error: \(String(describing: error?.localizedDescription))")
//        cleanUp()
    }
    
    // connected, checking transfer characteristics
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Pheriperal connected")
        
        centralManager?.stopScan()
        
        recivedData.length = 0
        
        // activating discovery callbacksž
        peripheral.delegate = self
        
        // check if uuid is matching
        peripheral.discoverServices([transferServiceUUID])
    }
    
    // the transfer service vas discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            print("Error discovering services: \(err.localizedDescription)")
            cleanUp()
            return
        }
        
        guard let services = peripheral.services else { return }
    
        // find the characteristicUUID in services
        for service in services {
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    // transfer characteristic was discovered
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            print("Error discovering characteristic \(err.localizedDescription)")
            cleanUp()
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        // double check in array for right charUUID
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(transferCharacteristicUUID) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    // notification that more data has arrived on the characteristics
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let err = error {
            print("Error discovering services \(err.localizedDescription)")
            return
        }
       
        guard let stringFromData = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            print("Invalid data")
            return
        }
        
        // check if end of reciveing data
        if stringFromData.isEqual("EOM") {
            // all data collected
            delegate?.recivedDataFromPheriperal()
//            textView.text = String(data: recivedData.copy() as! Data, encoding: String.Encoding.utf8)
            let test = String(data: recivedData.copy() as! Data, encoding: String.Encoding.utf8)
            print(test ?? "")
            
            // cancel subscription to characteristic and pheriperal
            peripheral.setNotifyValue(false, for: characteristic)
            centralManager?.cancelPeripheralConnection(peripheral)
        }
        // add reciveing data
        else {
            print("Recived: \(stringFromData)")
            recivedData.append(characteristic.value!)
        }
    }
    
    // notification if subscription/unsubscription happ
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Error changing nottification state: \(String(describing: error?.localizedDescription))")
        
        // if characteristicsUUID not matching
        guard characteristic.uuid.isEqual(transferCharacteristicUUID) else { return }
        
        // notification starting
        if characteristic.isNotifying {
            print("Notification began on \(characteristic)")
        } else {
            print("Notification stopped on \(characteristic) Disconecting")
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    // if dissconecting happ clean up local copy of peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral disconnected")
        
        discoveredPheriperal = nil
        
        // again start scaning
        scan()
    }
    
//    Call this when things either go wrong, or you're done with the connection.
//    This cancels any subscriptions if there are any, or straight disconnects if not.
//    (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
    private func cleanUp() {
        // pass if we are connected
        guard discoveredPheriperal?.state == .connected else { return }
        
        // check if subscribed to good characterstic on pheripal
        guard let services = discoveredPheriperal?.services else {
            cancelPeripheralConnection()
            return
        }
    
        for service in services {
            guard let characteristics = service.characteristics else { continue }
            
            for characteristic in characteristics {
                if characteristic.uuid.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
                    discoveredPheriperal?.setNotifyValue(false, for: characteristic)
                    return
                }
            }
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    fileprivate func cancelPeripheralConnection() {
        centralManager?.cancelPeripheralConnection(discoveredPheriperal!)
    }
    
    
    
}
