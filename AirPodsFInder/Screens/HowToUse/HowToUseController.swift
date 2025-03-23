import UIKit
import SnapKit
import Utilities
import CustomBlurEffectView
import ShadowImageButton

final class HowToUseController: UIViewController {
    
    private let viewModel = HowToUseViewModel()
    
    private var currentStep = 0
    
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
    
    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let dotsImageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 25)
        label.textColor = .init(hex: "#1C1B2A")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .medium, size: 18)
        label.textColor = .init(hex: "#9DA0B3")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Next".localized,
                font: .font(
                    weight: .semiBold,
                    size: 18
                ),
                textColor: .white,
                image: nil
            ),
            backgroundImageConfig: .init(
                image: .gradient,
                cornerRadius: 18,
                shadowConfig: .init(
                    color: .init(hex: "0077FF"),
                    opacity: 0.44,
                    offset: .init(width: 0, height: 10.5),
                    radius: 18
                )
            )
        )
        button.action = { [weak self] in
            self?.bottomButtonTapped()
        }
        return button
    }()
    
    private lazy var closeButton = UIButton().apply {
        $0.setImage(.close, for: .normal)
        $0.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        
        updateUI(model: viewModel.models[currentStep])
    }
    
    private func setupView() {
        Storage.shared.isFeedbackShown = true
        
        view.addSubviews(blurView)
        blurView.addSubviews(contentView)
        contentView.addSubviews(titleLabel, subtitleLabel, bottomButton, closeButton, imageView, dotsImageView)
    }
    
    private func setupConstraints() {
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(621)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        dotsImageView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).inset(-31)
            make.centerX.equalToSuperview()
            make.height.equalTo(11)
            make.width.equalTo(69)
        }
        
        imageView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).inset(-50)
            make.top.equalToSuperview().inset(133)
            make.left.right.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        bottomButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(66)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(33)
            $0.top.equalToSuperview().inset(27)
            $0.right.equalToSuperview().inset(24)
        }
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true)
    }
    
    @objc private func bottomButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if currentStep == 2 {
            close()
        } else {
            currentStep += 1
            updateUI(model: viewModel.models[currentStep])
        }
    }
    
    private func updateUI(model: HowToUseViewData) {
        DispatchQueue.main.async {
            self.bottomButton.updateTitle(title: model.bottomButtonTitle)
            self.imageView.image = UIImage(named: "howToUse_\(model.index)")
            self.dotsImageView.image = UIImage(named: "howToUseDots_\(model.index)")
            self.titleLabel.text = model.title
            self.subtitleLabel.text = model.subtitle
        }
    }
}
