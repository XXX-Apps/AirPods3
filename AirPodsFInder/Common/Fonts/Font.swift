import UIKit

struct Font {
    enum Weight: String {
        case light = "Sofia Pro Light"
        case regular = "Sofia Pro Regular"
        case medium = "Sofia Pro Medium"
        case semiBold = "Sofia Pro Semi Bold"
        case bold = "Sofia Pro Bold"
        case black = "Sofia Pro Black"
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
