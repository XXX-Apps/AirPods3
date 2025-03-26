import Foundation
import UIKit

enum SearchCellType {
    case search
    case device(model: DeviceModel)
}

struct DeviceModel {
    let name: String
    let distance: Double
    let type: DeviceType
}
 
