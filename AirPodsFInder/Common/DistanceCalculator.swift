import CoreBluetooth

final class DistanceCalculator {
    
    private var lastDistances: [UUID: Float] = [:]
    
    private let smoothingFactor: Float = 0.3
    
    func calculateSmoothedDistance(for peripheral: CBPeripheral, rssi: Int) -> Float {
        let txPower = -59
        
        guard rssi < 0 else { return -1.0 }
        
        let ratio = Double(rssi) / Double(txPower)
        let calculatedDistance: Float
        
        if ratio < 1.0 {
            calculatedDistance = Float(pow(ratio, 10))
        } else {
            calculatedDistance = Float((0.89976) * pow(ratio, 7.7095) + 0.111)
        }
        
        let lastDistance = lastDistances[peripheral.identifier] ?? calculatedDistance
        
        let smoothedDistance = lastDistance * (1.0 - smoothingFactor) + calculatedDistance * smoothingFactor
        
        lastDistances[peripheral.identifier] = smoothedDistance
        
        return smoothedDistance
    }
    
    func clearData(for deviceId: UUID) {
        lastDistances.removeValue(forKey: deviceId)
    }
    
    func clearAllData() {
        lastDistances.removeAll()
    }
}
