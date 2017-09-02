//
//  ViewController.swift
//  BluetoothDemo
//
//  Created by WJ on 15/11/5.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate,CBPeripheralDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var temperatuerLabel: UILabel!
    
    var centralManager:CBCentralManager!
    let peripherals = [CBPeripheral]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        temperatuerLabel.text = ""
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    
    
    
   //MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
        case .poweredOff:
            let alert = UIAlertController(title: "Bluetooth Turned Off", message: "Turn on bluetooth and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil ))
            present(alert, animated: true, completion: nil)
        case .unsupported:
            let alert = UIAlertController(title: "Bluetooth LE not available on this device", message: "TThis is not a iPhone 4S+ device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil ))
            present(alert, animated: true, completion: nil)
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil , options: nil)
            print("start scan")
        default:
            print("\(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            statusLabel.text = "Connecting to Peripheral"
            peripheral.delegate = self
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        statusLabel.text = "Discovering Services…"
        peripheral.discoverServices(nil )
    }
    
//    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
//        
//    }
//    
//    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
//        
//    }
    
    //MARK: - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        statusLabel.text = "Discovering characteristics…"
        var found = false
        for service in peripheral.services!{
            if service.uuid == CBUUID(string: "F000AA00-0451-4000-B000-000000000000"){
                peripheral.discoverCharacteristics(nil , for: service)
                found = true
            }
        }
        if !found{
            statusLabel.text = "This is not a Sensor Tag"
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        statusLabel.text = "Reading temperature…"
        for character in service.characteristics!{
            if character.uuid.uuidString == "F000AA02-0451-4000-B000-000000000000"{
                var parameter = NSInteger(1)
//                let data = Data(bytes: UnsafePointer<UInt8>(&parameter), count: 1)
                
                let data = NSData(bytes: &parameter, length: MemoryLayout<Int>.size)
                peripheral.writeValue(data as Data, for: character, type: .withResponse)
            }
            if character.uuid.uuidString == "F000AA01-0451-4000-B000-000000000000"{
                peripheral.setNotifyValue(true , for: character)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
       let temp = temperatureFormData(characteristic.value!)
        statusLabel.text = "Room temperature"
        temperatuerLabel.text = "\(round(temp*10)/10)°C"
    }
    
    
    func temperatureFormData(_ data:Data)->Float{
        var scratchVal=[UInt8](repeating: 0, count: data.count)
        (data as NSData).getBytes(&scratchVal, length: data.count)
        return fromByteArray(scratchVal, Float.self)
    }
    

    func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBufferPointer {
            return UnsafeRawPointer($0.baseAddress!).load(as: T.self)
        }
    }

}

