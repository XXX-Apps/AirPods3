import CoreBluetooth
import Combine

final class DistanceTrackingManager: NSObject {
    
    private let distanceCalculator = DistanceCalculator()
    
    // MARK: - Configuration
    struct Configuration {
        var txPower: Int = -59
        var maxTrackingDistance: Float = 10.0
        var updateInterval: TimeInterval = 1
        var smoothingFactor: Float = 1
    }
    
    // MARK: - Properties
    private var centralManager: CBCentralManager!
    private let configuration: Configuration
    private var targetDeviceId: UUID?
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var currentDistance: Float = -1
    @Published private(set) var currentPercentage: Int = 0
    @Published private(set) var connectionState: CBPeripheralState = .disconnected
    
    // MARK: - Initialization
    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Public Methods
    func startTracking(deviceId: UUID) {
        targetDeviceId = deviceId
        if centralManager.state == .poweredOn {
            startScanning()
        }
    }
    
    func stopTracking() {
        centralManager.stopScan()
        targetDeviceId = nil
        resetValues()
    }
    
    // MARK: - Private Methods
    private func startScanning() {
        centralManager.scanForPeripherals(
            withServices: nil,
            options: [
                CBCentralManagerScanOptionAllowDuplicatesKey: true,
                CBCentralManagerOptionShowPowerAlertKey: false
            ]
        )
    }
    
    private func calculatePercentage(distance: Float) -> Int {
        guard distance > 0 else { return 100 }
        
        let percentage = 100 - min(100, Int((distance / configuration.maxTrackingDistance) * 100))
        return max(0, percentage)
    }
    
    private func updateValues(for device: CBPeripheral, rssi: Int) {
        let rawDistance = distanceCalculator.calculateSmoothedDistance(for: device, rssi: rssi)
        let smoothedDistance = smoothDistance(rawDistance)
        let percentage = calculatePercentage(distance: smoothedDistance)
        
        currentDistance = smoothedDistance
        currentPercentage = percentage
        connectionState = device.state
    }
    
    private func smoothDistance(_ newDistance: Float) -> Float {
        guard newDistance >= 0 else { return newDistance }
        
        if currentDistance < 0 {
            return newDistance
        } else {
            return currentDistance * (1 - configuration.smoothingFactor) +
            newDistance * configuration.smoothingFactor
        }
    }
    
    private func resetValues() {
        currentDistance = -1
        currentPercentage = 0
        connectionState = .disconnected
    }
}

// MARK: - CBCentralManagerDelegate
extension DistanceTrackingManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn, targetDeviceId != nil {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        guard peripheral.identifier == targetDeviceId else { return }
        
        updateValues(for: peripheral, rssi: RSSI.intValue)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        guard peripheral.identifier == targetDeviceId else { return }
        connectionState = .connected
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDisconnectPeripheral peripheral: CBPeripheral,
                        error: Error?) {
        guard peripheral.identifier == targetDeviceId else { return }
        connectionState = .disconnected
    }
}
