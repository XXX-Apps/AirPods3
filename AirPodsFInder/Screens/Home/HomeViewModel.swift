import Foundation

final class HomeViewModel {
    
    var sections: [HomeSection] = []
    
    var onUpdate: (() -> Void)?
    
    func reloadData(isBluetoothOn: Bool) {
        sections.removeAll()
        sections = [
            .init(
                title: nil,
                cells: [.bluetooth(isOn: isBluetoothOn)]
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
