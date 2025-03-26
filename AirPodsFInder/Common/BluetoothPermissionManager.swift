import CoreBluetooth

class BluetoothPermissionManager: NSObject {
    static let shared = BluetoothPermissionManager()
    
    private var completion: ((Bool) -> Void)?
    private var didShowPermissionRequest = false
    
    private lazy var centralManager: CBCentralManager? = {
        return CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }()
    
    private override init() {
        super.init()
    }
    
    func requestBluetoothAccess(completion: @escaping (Bool) -> Void) {
        self.completion = completion
        
        let status = checkAuthorizationStatus()
        
        switch status {
        case .notDetermined:
            if !didShowPermissionRequest {
                _ = isBluetoothEnabled()
                didShowPermissionRequest = true
            } else {
                completion(false)
            }
            
        case .restricted, .denied:
            completion(false)
            
        case .allowedAlways:
            completion(true)
            
        @unknown default:
            completion(false)
        }
    }
    
    private func checkAuthorizationStatus() -> CBManagerAuthorization {
        return CBCentralManager.authorization
    }
}

extension BluetoothPermissionManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard let completion = completion else { return }
        
        DispatchQueue.main.async {
            let status = self.checkAuthorizationStatus()
            completion(status == .allowedAlways)
        }
    }
}

extension BluetoothPermissionManager {
    func isBluetoothEnabled() -> Bool {
        return centralManager?.state == .poweredOn
    }
}
