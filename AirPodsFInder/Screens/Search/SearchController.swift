import UIKit
import PremiumManager
import SnapKit
import Utilities
import ShadowImageButton

final class SearchController: BaseController {
    
    private let viewModel = SearchViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Searching...".localized
        label.font = .font(weight: .bold, size: 25)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var needCellsAnimation = true
    
    private lazy var closeButton: UIButton = {
        let view = UIButton()
        view.setImage(.grayClose, for: .normal)
        view.addTarget(self, action: #selector(close), for: .touchUpInside)
        return view
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView(image: .background)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.identifier)
        tableView.register(DeviceCell.self, forCellReuseIdentifier: DeviceCell.identifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        
        let cellHeight: CGFloat = 400
        let visibleCellsCount = 1
        
        let topInset = ((view.bounds.height - 30) - cellHeight) / 4
        
        tableView.contentInset = UIEdgeInsets(
            top: max(topInset, 0),
            left: 0,
            bottom: 100,
            right: 0
        )
      
        return tableView
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "FAQ for troubleshooting".localized,
                font: .font(
                    weight: .bold,
                    size: 18
                ),
                textColor: .white,
                image: .whiteQuestion
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
        button.backgroundColor = .init(hex: "4F86F2")
        button.action = { [weak self] in
            self?.openFAQ()
        }
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurNavigation(
            centerView: titleLabel,
            rightView: closeButton
        )
        
        setupUI()
        setupSubscriptions()
        
        viewModel.startScanning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.startScanning()
        
        checkFeedback()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewModel.stopScanning()
    }
    
    private func setupUI() {
        
        view.addSubviews(tableView, bottomButton)
        
        view.insertSubview(backgroundImageView, at: 0)
                
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.left.right.bottom.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(65)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupSubscriptions() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            self.bottomButton.isHidden = self.viewModel.cells.count > 1
            
            self.tableView.reloadData()
            
            if self.viewModel.cells.count > 1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.needCellsAnimation = false
                }
               
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            }
        }
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss()
    }
    
    @objc private func openFAQ() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        present(vc: FaqController())
    }
    
    private func checkFeedback() {
        Storage.shared.userActionCounter += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !Storage.shared.isFeedbackShown, Storage.shared.userActionCounter > 4 {
                UIApplication.topViewController()?.presentCrossDissolve(vc: FeedbackController())
            }
        }
    }
}

extension SearchController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .search:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier) as? SearchCell else {
                fatalError("Could not dequeue SearchCell")
            }
            return cell
        case .device(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.identifier) as? DeviceCell else {
                fatalError("Could not dequeue DeviceCell")
            }
            cell.configure(model: model, distance: model.distance)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .device(let device):
            
            guard PremiumManager.shared.isPremium.value else {
                present(vc: Paywall(isFromOnboarding: false))
                return
            }
            
            presentCrossDissolve(
                vc: DistanceController(
                    model: .init(
                        deviceName: device.name,
                        deviceType: device.type,
                        date: Date(),
                        deviceIdentifier: device.peripheral.identifier
                    )
                )
            )
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = viewModel.cells[indexPath.row]
        
        switch cellType {
        case .search:
            return viewModel.cells.count == 1 ? 400 : 300
        case .device:
            return 92
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if needCellsAnimation {
            let delay = 0.1 * Double(indexPath.section + indexPath.row)
            
            cell.alpha = 0
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            
            UIView.animate(
                withDuration: 0.4,
                delay: delay,
                options: .curveEaseInOut,
                animations: {
                    cell.alpha = 1
                    cell.transform = .identity
                }
            )
        }
    }
}
