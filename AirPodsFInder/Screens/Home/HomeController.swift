import UIKit
import SnapKit
import Utilities

final class HomeController: BaseController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finder Airpods".localized
        label.font = .font(weight: .black, size: 32)
        return label
    }()
    
    private lazy var settingsButton: UIButton = {
        let view = UIButton()
        view.setImage(.settings, for: .normal)
        view.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurNavigation(
            leftView: titleLabel,
            rightView: settingsButton
        )
        
        setupUI()
        setupSubscriptions()
    }
    
    private func setupUI() {
        
    }
    
    private func setupSubscriptions() {
        
    }
    
    @objc private func openSettings() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        present(vc: SettingsController())
    }
}
