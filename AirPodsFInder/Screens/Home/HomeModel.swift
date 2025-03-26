import Foundation
import UIKit

enum HomeCellType {

    case bluetooth(isOn: Bool)
    case emptyHistory
    case history(model: HistoryModel)
}

struct HistoryModel {
    let name: String
    let date: Date
    let type: DeviceType
}

struct HomeSection {
    var title: String?
    var cells: [HomeCellType]
}

enum DeviceType {
    
    case airPodsMax
    case airPods
    case airTag
    case appleWatch
    case iPhone
    case other
    
    var image: UIImage? {
        switch self {
        case .airPodsMax:
            return UIImage(named: "headphone")
        case .airPods:
            return UIImage(named: "pods")
        case .airTag:
            return UIImage(named: "tag")
        case .iPhone:
            return UIImage(named: "iPhone")
        case .appleWatch:
            return UIImage(named: "watch")
        default:
            return nil
        }
    }
}
 
