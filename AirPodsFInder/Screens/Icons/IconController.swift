import UIKit
import SnapKit
import CustomBlurEffectView

import UIKit

enum Icon: String, CaseIterable, Identifiable {
    case primary     = "AppIcon"
    case fisrt       = "AppIcon-1"
    
    var image: UIImage? {
        switch self {
        case .primary: return .playstore
        case .fisrt: return .playstore1
        }
    }

    var id: String { self.rawValue }
}

final class IconsController: UIViewController {
    
    let icons: [Icon] = Icon.allCases
    private var selectedIndexPaths: [IndexPath] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: IconCell.identifier)
        return collectionView
    }()
    
    private let blurView = CustomBlurEffectView().apply {
        $0.blurRadius = 3
        $0.colorTint = .init(hex: "171313")
        $0.colorTintAlpha = 0.3
    }
    
    private let contentView = UIView().apply {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 30
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private let titleLabel = UILabel().apply {
        $0.text = "Change icon".localized
        $0.font = .font(weight: .bold, size: 25)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private lazy var closeButton = UIButton().apply {
        $0.setImage(.close, for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        setupInitialSelection()
    }
    
    private func setupView() {
        
        view.addSubviews(blurView)
        blurView.addSubviews(contentView)
        contentView.addSubviews(titleLabel, closeButton, collectionView)
    }
    
    private func setupConstraints() {
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(297)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(33)
            $0.top.equalToSuperview().inset(27)
            $0.right.equalToSuperview().inset(24)
        }
        
        let inset = (UIScreen.main.bounds.width - 325) / 2
        
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(inset)
            make.bottom.equalToSuperview().inset(54)
            make.height.equalTo(150)
        }
    }
    
    private func setupInitialSelection() {
        let currentIconName = UIApplication.shared.alternateIconName
        if let index = icons.firstIndex(where: { $0.rawValue == currentIconName }) {
            let indexPath = IndexPath(item: index, section: 0)
            selectedIndexPaths = [indexPath]
        } else {
            selectedIndexPaths = [IndexPath(item: 0, section: 0)]
        }
        
        collectionView.reloadData()
    }
    
    func changeAppIcon(to icon: Icon) {
        let iconName: String? = (icon != .primary) ? icon.rawValue : nil

        guard UIApplication.shared.alternateIconName != iconName else { return }

        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print("Failed request to update the app’s icon: \(error)")
            }
        }
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true)
    }
}

extension IconsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IconCell.identifier, for: indexPath) as? IconCell else {
            return UICollectionViewCell()
        }
        
        let icon = icons[indexPath.row]
        let isSelected = selectedIndexPaths.contains(indexPath)
        cell.configure(with: icon.image, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedIndexPaths.first != indexPath else { return }
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        let previousIndexPath = selectedIndexPaths.first
        
        selectedIndexPaths = [indexPath]
        
        changeAppIcon(to: icons[indexPath.row])
        
        var indexPathsToUpdate = [indexPath]
        if let previousIndexPath = previousIndexPath {
            indexPathsToUpdate.append(previousIndexPath)
        }
        
        collectionView.performBatchUpdates {
            collectionView.reloadItems(at: indexPathsToUpdate)
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
