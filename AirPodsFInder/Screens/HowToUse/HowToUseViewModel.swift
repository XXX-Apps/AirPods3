import UIKit

struct HowToUseViewData {
    let title: String
    let subtitle: String
    let index: Int
    let bottomButtonTitle: String
}

final class HowToUseViewModel {
    let models: [HowToUseViewData] = [
        .init(
            title: "Activate Bluetooth".localized,
            subtitle: "Turn on Bluetooth to detect your device".localized,
            index: 0,
            bottomButtonTitle: "Next".localized
        ),
        .init(
            title: "Select device".localized,
            subtitle: "Scan for lost devices and select one to track".localized,
            index: 1,
            bottomButtonTitle: "Next".localized
        ),
        .init(
            title: "Walk around".localized,
            subtitle: "Walk slowly until the signal strength improves".localized,
            index: 2,
            bottomButtonTitle: "Got it!".localized
        )
    ]
}
