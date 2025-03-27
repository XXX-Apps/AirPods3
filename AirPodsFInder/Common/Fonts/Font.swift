import UIKit

struct Font {
    enum Weight: String {
        case medium = "Hellix-Medium"
        case semiBold = "Hellix-SemiBold"
        case bold = "Hellix-Bold"
        case black = "Hellix-Black"
    }

    static func font(weight: Weight, size: CGFloat) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UIFont {
    static func font(weight: Font.Weight, size: CGFloat) -> UIFont {
        return Font.font(weight: weight, size: size)
    }
}
