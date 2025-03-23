import UIKit

final class SettingsViewModel {
    
    var onUpdate: (() -> Void)?
    
    var cells: [SettingsCellType] = []
    
    func configureCells(isPremium: Bool = false) {
        
        cells.removeAll()
        
        if !isPremium {
            cells.append(.premium)
        }
    
        cells.append(.settings(model: .howToUse))
        cells.append(.settings(model: .changeIcon))
        cells.append(.settings(model: .faq))
        cells.append(.settings(model: .privacy))
        cells.append(.settings(model: .terms))
        
        onUpdate?()
    }
}
