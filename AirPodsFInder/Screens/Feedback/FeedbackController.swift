import UIKit
import SafariServices
import StoreKit
import SnapKit
import CustomBlurEffectView
import ShadowImageButton
import Utilities

final class FeedbackController: UIViewController {
    
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
        $0.image = .feedback
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        label.attributedText = "We’d love to know what you think!".localized.attributedString(
            font: .font(weight: .semiBold, size: 24),
            aligment: .center,
            color: .init(hex: "#1C1B2A"),
            lineSpacing: 5,
            maxHeight: 50
        )
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        label.attributedText = "Please take a moment to review our app and share your feedback".localized.attributedString(
            font: .font(weight: .medium, size: 18),
            aligment: .center,
            color: .init(hex: "838DA7"),
            lineSpacing: 5,
            maxHeight: 20
        )
        return label
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Write a feedback".localized,
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
            self?.feedbackTapped()
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
    }
    
    private func setupView() {
        Storage.shared.isFeedbackShown = true
        
        view.addSubviews(blurView)
        blurView.addSubviews(contentView)
        contentView.addSubviews(imageView, titleLabel, subtitleLabel, bottomButton, closeButton)
    }
    
    private func setupConstraints() {
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(642)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(370)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subtitleLabel.snp.top).offset(-17)
            $0.left.right.equalToSuperview().inset(22)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(bottomButton.snp.top).offset(-21)
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
    
    @objc private func feedbackTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(Config.appId)3?action=write-review") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
