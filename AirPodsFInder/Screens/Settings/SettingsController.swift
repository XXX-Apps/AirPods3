import UIKit
import SafariServices
import SnapKit
import RxSwift
import PremiumManager

final class SettingsController: BaseController {
    
    private let viewModel = SettingsViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings".localized
        label.font = .font(weight: .black, size: 25)
        return label
    }()
    
    private lazy var topButton: UIButton = {
        let button = UIButton()
        button.setImage(.close, for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(SettingsPremiumCell.self, forCellReuseIdentifier: SettingsPremiumCell.identifier)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurNavigation(
            leftView: titleLabel,
            rightView: topButton
        )
        
        setupUI()
        setupSubscriptions()
    }
    
    func setupUI() {
        
        view.addSubviews(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupSubscriptions() {
        
        PremiumManager.shared.isPremium
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isPremium in
                self.viewModel.configureCells(isPremium: isPremium)
            })
            .disposed(by: disposeBag)
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true)
    }
    
    private func openPaywall() {
//        present(PaywallManager.shared.getPaywall(), animated: true)
    }
    
    private func openChangeIcon() {
//        presentCrossDisolve(vc: IconsController())
    }
    
    private func openHowToUse() {

    }
    
    private func openFaq() {

    }
    
    private func openPrivacy() {
        if let url = URL(string: Config.privacy) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    private func openTerms() {
        if let url = URL(string: Config.terms) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

extension SettingsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .premium:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsPremiumCell.identifier) as? SettingsPremiumCell else {
                fatalError("Could not dequeue SettingsPremiumCell")
            }
            return cell
        case .settings(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier) as? SettingsCell else {
                fatalError("Could not dequeue SettingsPremiumCell")
            }
            cell.configure(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .premium:
            openPaywall()
        case .settings(let type):
            switch type {
            case .changeIcon:
                openChangeIcon()
            case .howToUse:
                openHowToUse()
            case .faq:
                openFaq()
            case .privacy:
                openPrivacy()
            case .terms:
                openTerms()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .premium:
            return 236
        case .settings:
            return 95
        }
    }
}

