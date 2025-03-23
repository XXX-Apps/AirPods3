import UIKit

enum SettingsType {

    case howToUse
    case changeIcon
    case faq
    case privacy
    case terms
    
    var image: UIImage? {
        switch self {
        case .changeIcon:
            return UIImage(named: "changeIcon")
        case .howToUse:
            return UIImage(named: "howToUse")
        case .faq:
            return UIImage(named: "faq")
        case .privacy:
            return UIImage(named: "privacy")
        case .terms:
            return UIImage(named: "terms")
        }
    }
    
    var title: String {
        switch self {
        case .changeIcon:
            return "Change icon".localized
        case .howToUse:
            return "How it functions".localized
        case .faq:
            return "FAQ".localized
        case .privacy:
            return "Privacy Policy".localized
        case .terms:
            return "Terms of use".localized
        }
    }
}

enum SettingsCellType {
    case premium
    case settings(model: SettingsType)
}
