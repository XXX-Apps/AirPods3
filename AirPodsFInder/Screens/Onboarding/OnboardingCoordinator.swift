import UIKit
import Utilities

class OnboardingCoordinator {
    
    private let window: UIWindow
    private var currentIndex = 0
    private let models: [OnboardingModel] = [
        OnboardingModel(
            image: UIImage(named: "onboarding_0"),
            title: "Locate your lost device in seconds".localized,
            higlitedText: "Locate".localized,
            rating: false
        ),
        OnboardingModel(
            image: UIImage(named: "onboarding_1"),
            title: "Select a device to locate".localized,
            higlitedText: "Select".localized,
            rating: true
        ),
        OnboardingModel(
            image: UIImage(named: "onboarding_2"),
            title: "Top choice for users".localized,
            higlitedText: "Top choice".localized,
            rating: false
        ),
        OnboardingModel(
            image: UIImage(named: "onboarding_3"),
            title: "Locate devices effortlessly".localized,
            higlitedText: "Locate2".localized,
            rating: false
        )
    ]
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showNextViewController()
    }
    
    private func showNextViewController() {
        guard currentIndex < models.count else {
            transitionToPaywall()
            return
        }
        
        let model = models[currentIndex]
        let viewController = OnboardingController(model: model, coordinator: self, shadowImage: currentIndex == 0 ? .onboardingShadow : .onboardingShadow1)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        currentIndex += 1
    }
    
    func goToNextScreen() {
        showNextViewController()
    }
    
    private func transitionToPaywall() {
        let vc = Paywall(isFromOnboarding: true)
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
