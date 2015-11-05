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
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch central.state{
        case .PoweredOff:
            let alert = UIAlertController(title: "Bluetooth Turned Off", message: "Turn on bluetooth and try again", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil ))
            presentViewController(alert, animated: true, completion: nil)
        case .Unsupported:
            let alert = UIAlertController(title: "Bluetooth LE not available on this device", message: "TThis is not a iPhone 4S+ device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil ))
            presentViewController(alert, animated: true, completion: nil)
        case .PoweredOn:
            centralManager.scanForPeripheralsWithServices(nil , options: nil)
            print("start scan")
        default:
            print("\(central.state.rawValue)")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            statusLabel.text = "Connecting to Peripheral"
            peripheral.delegate = self
            central.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
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
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        statusLabel.text = "Discovering characteristics…"
        var found = false
        for service in peripheral.services!{
            if service.UUID == CBUUID(string: "F000AA00-0451-4000-B000-000000000000"){
                peripheral.discoverCharacteristics(nil , forService: service)
                found = true
            }
        }
        if !found{
            statusLabel.text = "This is not a Sensor Tag"
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        statusLabel.text = "Reading temperature…"
        for character in service.characteristics!{
            if character.UUID == "F000AA02-0451-4000-B000-000000000000"{
                var parameter = NSInteger(1)
                let data = NSData(bytes: &parameter, length: 1)
                peripheral.writeValue(data, forCharacteristic: character, type: .WithResponse)
            }
            if character.UUID == "F000AA01-0451-4000-B000-000000000000"{
                peripheral.setNotifyValue(true , forCharacteristic: character)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
       let temp = temperatureFormData(characteristic.value!)
        statusLabel.text = "Room temperature"
        temperatuerLabel.text = "\(round(temp*10)/10)°C"
    }
    
    
    func temperatureFormData(data:NSData)->Float{
        var scratchVal=[UInt8](count: data.length, repeatedValue: 0)
        data.getBytes(&scratchVal, length: data.length)
        return fromByteArray(scratchVal, Float.self)
    }
    

    func fromByteArray<T>(value: [UInt8], _: T.Type) -> T {
        return value.withUnsafeBufferPointer {
            return UnsafePointer<T>($0.baseAddress).memory
        }
    }

}

