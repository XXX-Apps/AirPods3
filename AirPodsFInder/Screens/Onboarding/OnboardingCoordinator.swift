import UIKit

class OnboardingCoordinator {
    
    private let window: UIWindow
    private var currentIndex = 0
    private let models: [OnboardingModel]
    
    init(window: UIWindow, models: [OnboardingModel]) {
        self.window = window
        self.models = models
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
        let viewController = OnboardingController(model: model, coordinator: self)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        
        currentIndex += 1
    }
    
    func goToNextScreen() {
        showNextViewController()
    }
    
    private func transitionToPaywall() {
//        let vc = PaywallManager.shared.getPaywall(isFromOnboarding: true)
//        window.rootViewController = vc
//        window.makeKeyAndVisible()
    }
}
