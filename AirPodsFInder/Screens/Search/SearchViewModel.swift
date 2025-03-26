import Foundation
import CoreBluetooth
import UIKit

enum SearchCellType {
    case search
    case device(model: BluetoothDevice)
}

final class SearchViewModel {
    
    let calculator = DistanceCalculator()
    
    private let bluetoothManager = BluetoothManager()
    
    private var updateTimer: Timer?
    private let updateInterval: TimeInterval = 3.0
    
    var cells: [SearchCellType] = []
    var devices: [BluetoothDevice] = [] {
        didSet {
            prepareCells()
        }
    }
    
    var onUpdate: (() -> Void)?
    
    init() {
        bluetoothManager.delegate = self
        startUpdating()
    }
    
    private func startUpdating() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.onUpdate?()
        }
    }
    
    func stopUpdating() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    deinit {
        stopUpdating()
    }
    
    func startScanning() {
        bluetoothManager.startScanning()
    }
    
    func prepareCells() {
        cells = [.search] + sortedDevices().map { .device(model: $0) }
    }
    
    func calculateDistance(for device: BluetoothDevice) -> Double {
        return Double(calculator.calculateSmoothedDistance(for: device))
    }
    
    private func sortedDevices() -> [BluetoothDevice] {
        return devices.sorted {
            if $0.isConnected != $1.isConnected {
                return $0.isConnected
            }
            return $0.rssi > $1.rssi
        }
    }
    
    func stopScanning() {
        bluetoothManager.stopScanning()
    }
}

extension SearchViewModel: BluetoothManagerDelegate {
    func didDiscoverDevice(_ device: BluetoothDevice) {
        if !devices.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            devices.append(device)
        }
    }
    
    func didUpdateDevice(_ device: BluetoothDevice) {
        if let index = devices.firstIndex(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            devices[index] = device
        }
    }
    
    func didLoseDevice(_ device: BluetoothDevice) {
        devices.removeAll { $0.peripheral.identifier == device.peripheral.identifier }
    }
}

