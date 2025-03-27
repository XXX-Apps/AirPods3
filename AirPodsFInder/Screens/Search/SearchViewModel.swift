import Foundation
import CoreBluetooth
import UIKit

enum SearchCellType {
    case search
    case device(model: BluetoothDevice)
}
import Combine

final class SearchViewModel {
    
    // MARK: - Properties
    private let bluetoothManager = BluetoothManager()
    private var distanceTrackers: [UUID: DistanceTrackingManager] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    private var updateTimer: Timer?
    private let updateInterval: TimeInterval = 3.0
    
    var cells: [SearchCellType] = []
    var devices: [BluetoothDevice] = [] {
        didSet {
            updateDistanceTrackers()
            prepareCells()
        }
    }
    
    var onUpdate: (() -> Void)?
    
    // MARK: - Initialization
    init() {
        bluetoothManager.delegate = self
        startUpdating()
    }
    
    private func startUpdating() {
        prepareCells()
        onUpdate?()
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            self?.onUpdate?()
        }
    }
    
    // MARK: - Public Methods
    func startScanning() {
        bluetoothManager.startScanning()
    }
    
    func stopScanning() {
        bluetoothManager.stopScanning()
        distanceTrackers.values.forEach { $0.stopTracking() }
        distanceTrackers.removeAll()
    }
    
    // MARK: - Private Methods
    private func updateDistanceTrackers() {
        let currentIds = devices.map { $0.peripheral.identifier }
        distanceTrackers = distanceTrackers.filter { currentIds.contains($0.key) }
        
        for device in devices where distanceTrackers[device.peripheral.identifier] == nil {
            addTracker(for: device)
        }
    }
    
    private func addTracker(for device: BluetoothDevice) {
        let tracker = DistanceTrackingManager()
        distanceTrackers[device.peripheral.identifier] = tracker
        
        tracker.$currentPercentage
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateDevice(deviceId: device.peripheral.identifier)
            }
            .store(in: &cancellables)
        
        tracker.startTracking(deviceId: device.peripheral.identifier)
    }
    
    private func updateDevice(deviceId: UUID) {
        guard let index = devices.firstIndex(where: { $0.peripheral.identifier == deviceId }),
              let tracker = distanceTrackers[deviceId] else { return }
        
        devices[index].distance = Double(tracker.currentDistance)
        devices[index].rssi = Double(Int(tracker.currentPercentage))
        
        prepareCells()
    }
    
    private func prepareCells() {
        cells = [.search] + sortedDevices().map { .device(model: $0) }
    }
    
    private func sortedDevices() -> [BluetoothDevice] {
        return devices.sorted {
            if $0.isConnected != $1.isConnected {
                return $0.isConnected
            }
            return $0.rssi > $1.rssi
        }
    }
}

// MARK: - BluetoothManagerDelegate
extension SearchViewModel: BluetoothManagerDelegate {
    func didDiscoverDevice(_ device: BluetoothDevice) {
        if !devices.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            devices.append(device)
        }
    }
    
    func didUpdateDevice(_ device: BluetoothDevice) {}
    
    func didLoseDevice(_ device: BluetoothDevice) {
        distanceTrackers[device.peripheral.identifier]?.stopTracking()
        distanceTrackers.removeValue(forKey: device.peripheral.identifier)
        devices.removeAll { $0.peripheral.identifier == device.peripheral.identifier }
    }
}
