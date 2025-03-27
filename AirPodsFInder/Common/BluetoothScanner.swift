import CoreBluetooth

class BluetoothManager: NSObject {
    
    private var centralManager: CBCentralManager!
    private var discoveredDevices = [UUID: BluetoothDevice]()
    weak var delegate: BluetoothManagerDelegate?
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        centralManager.scanForPeripherals(withServices: nil, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: true,
            CBCentralManagerOptionShowPowerAlertKey: true
        ])
    }
    
    func stopScanning() {
        centralManager.stopScan()
    }
    
    private func createDevice(from peripheral: CBPeripheral, type: DeviceType, name: String, rssi: Double) -> BluetoothDevice {
        return BluetoothDevice(
            peripheral: peripheral,
            isConnected: peripheral.state == .connected,
            lastSeen: Date(),
            type: type,
            batteryLevel: nil,
            name: name,
            rssi: rssi
        )
    }
}

extension BluetoothManager {
    private func getDeviceName(from peripheral: CBPeripheral, advertisementData: [String: Any]) -> String? {
        if let localName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            return localName
        }
        
        if let systemName = getSystemDeviceName(uuid: peripheral.identifier) {
            return systemName
        }
        
        if let peripheralName = peripheral.name, !peripheralName.isEmpty {
            return peripheralName
        }
        
        return nil
    }
    
    private func getSystemDeviceName(uuid: UUID) -> String? {
        let connectedDevices = centralManager.retrieveConnectedPeripherals(withServices: [])
        return connectedDevices.first { $0.identifier == uuid }?.name
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        startScanning()
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let deviceName = getDeviceName(from: peripheral, advertisementData: advertisementData)
        guard let deviceName else {
            return
        }
        
        let device = createDevice(
            from: peripheral,
            type: getDeviceType(from: peripheral, advertisementData: advertisementData),
            name: deviceName,
            rssi: RSSI.doubleValue
        )
        
        if discoveredDevices[peripheral.identifier] == nil {
            discoveredDevices[peripheral.identifier] = device
            delegate?.didDiscoverDevice(device)
        } else {
            discoveredDevices[peripheral.identifier] = device
            delegate?.didUpdateDevice(device)
        }
    }
}

protocol BluetoothManagerDelegate: AnyObject {
    func didDiscoverDevice(_ device: BluetoothDevice)
    func didUpdateDevice(_ device: BluetoothDevice)
    func didLoseDevice(_ device: BluetoothDevice)
}

class BluetoothDevice {
    internal init(peripheral: CBPeripheral, isConnected: Bool, lastSeen: Date, type: DeviceType, batteryLevel: Int? = nil, name: String, rssi: Double, distance: Double? = nil) {
        self.peripheral = peripheral
        self.isConnected = isConnected
        self.lastSeen = lastSeen
        self.type = type
        self.batteryLevel = batteryLevel
        self.name = name
        self.rssi = rssi
        self.distance = distance
    }
    
    let peripheral: CBPeripheral
    var isConnected: Bool
    var lastSeen: Date
    var type: DeviceType
    var batteryLevel: Int?
    let name: String
    var rssi: Double
    var distance: Double?
}

extension BluetoothManager {

    func getDeviceType(
        from peripheral: CBPeripheral,
        advertisementData: [String: Any]
    ) -> DeviceType {
        
        if let name = peripheral.name?.lowercased() {
            if name.contains("airpod") {
                if name.contains("max") {
                    return .airPodsMax
                }
                return .airPods
            } else if name.contains("airtag") {
                return .airTag
            } else if name.contains("watch") {
                return .appleWatch
            } else if name.contains("iphone") {
                return .iPhone
            }
        }
        
        return .other
    }
}
