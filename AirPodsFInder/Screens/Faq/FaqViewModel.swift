struct FaqModel {
    let title: String
    let subtitle: String
}

final class FaqViewModel {
    
    let models: [FaqModel] = [
        .init(
            title: "How it functions?".localized,
            subtitle: "The app uses Bluetooth signals to estimate the distance between your phone and your AirPods. The closer you get, the stronger the signal, helping you track them down.".localized
        ),
        .init(
            title: "Can I find AirPods if they are in the case?".localized,
            subtitle: "No, AirPods only emit a Bluetooth signal when they are out of the case. If they are inside, you may need to check the last known location where they were connected.".localized
        ),
        .init(
            title: "Will this app work if my AirPods are lost outdoors?".localized,
            subtitle: "If they are within Bluetooth range, yes. But if they are too far away, the app won’t detect them, and you may need to rely on their last known location.".localized
        ),
        .init(
            title: "Why is my device not appearing?".localized,
            subtitle: "The displayed percentage may fluctuate due to the connection type and potential obstacles between you and your device.".localized
        )
    ]
}
