import UIKit
import SnapKit
import Utilities
import ShadowImageButton

final class HomeController: BaseController {
    
    private let viewModel = HomeViewModel()
    
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
    
    private let shadowImageView: UIImageView = {
        let view = UIImageView(image: .shadowWhite)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(BluetoothCell.self, forCellReuseIdentifier: BluetoothCell.identifier)
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.identifier)
        tableView.register(EmptyHistoryCell.self, forCellReuseIdentifier: EmptyHistoryCell.identifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        return tableView
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Need assistance?".localized,
                font: .font(
                    weight: .bold,
                    size: 18
                ),
                textColor: .init(hex: "#181818"),
                image: .blueQuestion
            ),
            backgroundImageConfig: .init(
                image: nil,
                cornerRadius: 18,
                shadowConfig: .init(
                    color: UIColor.black,
                    opacity: 0.08,
                    offset: .init(width: 0, height: 3),
                    radius: 18
                )
            )
        )
        button.backgroundColor = .white
        button.action = { [weak self] in
            self?.openHowToUse()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurNavigation(
            leftView: titleLabel,
            rightView: settingsButton
        )
        
        setupUI()
        setupSubscriptions()
        
        viewModel.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: .init("updateHistory"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        
        view.addSubviews(tableView, shadowImageView, bottomButton)
                
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        shadowImageView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(231)
        }
        
        bottomButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(65)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupSubscriptions() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func openSettings() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        present(vc: SettingsController())
    }
    
    @objc private func openHowToUse() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        presentCrossDissolve(vc: HowToUseController())
    }
    
    @objc private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    @objc private func update() {
        viewModel.reloadData()
    }
}

extension HomeController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.sections[indexPath.section].cells[indexPath.row]
        
        switch cellType {
        case .bluetooth(let isOn):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BluetoothCell.identifier) as? BluetoothCell else {
                fatalError("Could not dequeue BluetoothCell")
            }
            cell.confgiure(isOn: isOn)
            cell.onAction = { [weak self] in
                guard let self else { return }
                if self.viewModel.bluetoothManager.isBluetoothEnabled() {
                    self.present(vc: SearchController())
                } else {
                    self.openAppSettings()
                }
            }
            return cell
        case .emptyHistory:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: EmptyHistoryCell.identifier) as? EmptyHistoryCell else {
                fatalError("Could not dequeue EmptyHistoryCell")
            }
       
            return cell
        case .history(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.identifier) as? HistoryCell else {
                fatalError("Could not dequeue HistoryCell")
            }
            cell.configure(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let cellType = viewModel.sections[indexPath.section].cells[indexPath.row]
        
        switch cellType {
        case .history(let model):
            presentCrossDissolve(vc: DistanceController(model: model))
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = viewModel.sections[indexPath.section].cells[indexPath.row]
        
        switch cellType {
        case .bluetooth:
            return 335
        case .emptyHistory:
            return 197
        case .history:
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let model = viewModel.sections[section]
        
        if section == 1 {
            let headerView = UIView()
            let label = UILabel().apply {
                $0.text = model.title
                $0.font = .font(weight: .bold, size: 25)
                $0.textColor = .init(hex: "#181818")
            }
            headerView.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(21)
                make.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.top.equalToSuperview()
            }
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}
