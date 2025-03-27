import Foundation
import StorageManager
import CoreBluetooth

struct HistoryModel: Codable {
    init(deviceName: String, deviceType: DeviceType, date: Date, deviceIdentifier: UUID) {
        self.deviceName = deviceName
        self.deviceType = deviceType
        self.date = date
        self.deviceIdentifier = deviceIdentifier
    }
    
    let deviceName: String
    let deviceType: DeviceType
    let date: Date
    let deviceIdentifier: UUID
}

final class Storage {
    
    // MARK: - Properties
    static let shared = Storage()
    private let storageManager: StorageManager = .shared
    
    // MARK: - Constants
    private enum Constants {
        static let onboardingShownKey = "onboarding_shown"
        static let feedbackShownKey = "feedback_shown"
        static let deviceHistoryKey = "bluetooth_device_history"
        static let userActionCounter = "user_action_counter"
        static let maxHistoryCount = 500
    }
    
    // MARK: - Public Properties
    var isOnboardingShown: Bool {
        get { storageManager.get(forKey: Constants.onboardingShownKey, defaultValue: false) }
        set { storageManager.set(newValue, forKey: Constants.onboardingShownKey) }
    }
    
    var isFeedbackShown: Bool {
        get { storageManager.get(forKey: Constants.feedbackShownKey, defaultValue: false) }
        set { storageManager.set(newValue, forKey: Constants.feedbackShownKey) }
    }
    
    var userActionCounter: Int {
        get {
            storageManager.get(forKey: Constants.userActionCounter, defaultValue: 0)
        }
        set {
            storageManager.set(newValue, forKey: Constants.userActionCounter)
        }
    }
    
    // MARK: - Device History
    func saveDeviceToHistory(_ model: HistoryModel) {
        var history = getDeviceHistory()
        
        history.removeAll { $0.deviceIdentifier == model.deviceIdentifier }
        
        history.append(model)
        
        history.sort { $0.date > $1.date }
        
        if history.count > Constants.maxHistoryCount {
            history = Array(history.prefix(Constants.maxHistoryCount))
        }
        
        if let encoded = try? JSONEncoder().encode(history) {
            storageManager.set(encoded, forKey: Constants.deviceHistoryKey)
        }
    }
    
    func getDeviceHistory() -> [HistoryModel] {
        guard let history = try? JSONDecoder().decode([HistoryModel].self, from: storageManager.get(forKey: Constants.deviceHistoryKey, defaultValue: Data())) else {
            return []
        }
        return history
    }
    
    func clearDeviceHistory() {
        storageManager.remove(forKey: Constants.deviceHistoryKey)
    }
    
    func removeDeviceFromHistory(with identifier: UUID) {
        var history = getDeviceHistory()
        history.removeAll { $0.deviceIdentifier == identifier }
        
        if let encoded = try? JSONEncoder().encode(history) {
            storageManager.set(encoded, forKey: Constants.deviceHistoryKey)
        }
    }
}
