import Foundation

final class HomeViewModel {
    
    let bluetoothManager = BluetoothPermissionManager.shared
        
    var sections: [HomeSection] = []
    
    var onUpdate: (() -> Void)?
    
    func viewDidLoad() {
        requestBluetoothAccess()
    }
    
    private func requestBluetoothAccess() {
        bluetoothManager.requestBluetoothAccess { [weak self] granted in
            DispatchQueue.main.async {
                guard let self else { return }
                if granted {
                    self.reloadData()
                } else {
                    self.reloadData()
                }
            }
        }
    }
    
    func reloadData() {
        sections.removeAll()
        sections = [
            .init(
                title: nil,
                cells: [.bluetooth(isOn: bluetoothManager.isBluetoothEnabled())]
            )
        ]
        
        let historyCells: [HomeCellType] = [
            .history(model: .init(name: "AirTag", date: Date(), type: .airTag)),
            .history(model: .init(name: "AirTag", date: Date(), type: .airTag)),
            .history(model: .init(name: "AirTag", date: Date(), type: .airPodsMax)),
            .history(model: .init(name: "AirTag", date: Date(), type: .airTag)),
            .history(model: .init(name: "AirTag", date: Date(), type: .airPods))
        ]
        
        sections.append(.init(
            title: "History".localized,
            cells: historyCells
        ))
        
        onUpdate?()
    }
}
