import Foundation

final class SearchViewModel {
    
    var cells: [SearchCellType] = []
    
    var onUpdate: (() -> Void)?
    
    func reloadData() {
        cells.removeAll()
        
        cells.append(.search)
        
        cells.append(.device(model: .init(name: "Air Pods MAX", distance: 10.4, type: .airPodsMax)))
        cells.append(.device(model: .init(name: "Air Tag", distance: 1.4, type: .airTag)))
        cells.append(.device(model: .init(name: "Air Pods", distance: 0.2, type: .airPods)))
        
        onUpdate?()
    }
}
