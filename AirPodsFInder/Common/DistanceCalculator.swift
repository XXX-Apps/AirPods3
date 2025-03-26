import CoreBluetooth

final class DistanceCalculator {
    
    func calculateSmoothedDistance(for device: BluetoothDevice) -> Float {
        let txPower = -59
        
        if device.rssi >= 0 {
            return -1.0
        }
        
        let ratio = Double(device.rssi) / Double(txPower)
        if ratio < 1.0 {
            return Float(pow(ratio, 10))
        } else {
            return Float((0.89976) * pow(ratio, 7.7095) + 0.111)
        }
    }
}
