import Foundation
import StorageManager

final class Storage {

    // MARK: - Properties
    
    static let shared = Storage()

    private let storageManager: StorageManager = .shared

    // MARK: - Public Properties

    var isOnboardingShown: Bool {
        get {
            storageManager.get(forKey: Constants.onboardingShownKey, defaultValue: false)
        }
        set {
            storageManager.set(newValue, forKey: Constants.onboardingShownKey)
        }
    }

    var isFeedbackShown: Bool {
        get {
            storageManager.get(forKey: Constants.feedbackShownKey, defaultValue: false)
        }
        set {
            storageManager.set(newValue, forKey: Constants.feedbackShownKey)
        }
    }

    // MARK: - Constants

    private enum Constants {
        static let onboardingShownKey = "onboarding_shown"
        static let feedbackShownKey = "feedback_shown"
    }
}

