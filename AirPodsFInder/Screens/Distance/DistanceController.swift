import UIKit
import Combine
import SafariServices
import StoreKit
import SnapKit
import CustomBlurEffectView
import ShadowImageButton
import Utilities
import Lottie

final class DistanceController: UIViewController {
    
    private let blurView = CustomBlurEffectView().apply {
        $0.blurRadius = 3
        $0.colorTint = .init(hex: "171313")
        $0.colorTintAlpha = 0.3
    }
    
    private let contentView = UIView().apply {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 44
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private lazy var animationView: LottieAnimationView = {
        let path = Bundle.main.path(
            forResource: "distance",
            ofType: "json"
        ) ?? ""
        let animationView = LottieAnimationView(filePath: path)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        return animationView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .font(weight: .bold, size: 25)
        label.textColor = .init(hex: "#1C1B2A")
        label.textAlignment = .center
        label.text = model.deviceName
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = .font(weight: .bold, size: 60)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        label.attributedText = "Adjust your position until the signal strength improves".localized.attributedString(
            font: .font(weight: .medium, size: 18),
            aligment: .center,
            color: .init(hex: "#9DA0B3"),
            lineSpacing: 5,
            maxHeight: 20
        )
        return label
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "I found it!".localized,
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
    
    private let model: HistoryModel
    private let trackingManager = DistanceTrackingManager()
    private var cancellables = Set<AnyCancellable>()
    
    init(model: HistoryModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupDistanceTracking()
    }
    
    private func setupDistanceTracking() {
        trackingManager.startTracking(deviceId: model.deviceIdentifier)
        
        trackingManager.$currentPercentage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] percentage in
                self?.percentLabel.text = "\(percentage)%"
                
                UIView.transition(
                    with: self?.percentLabel ?? UILabel(),
                    duration: 0.2,
                    options: .transitionCrossDissolve,
                    animations: nil,
                    completion: nil
                )
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        view.addSubviews(blurView)
        blurView.addSubviews(contentView)
        contentView.addSubviews(animationView, titleLabel, subtitleLabel, bottomButton, closeButton, percentLabel)
    }
    
    private func setupConstraints() {
        blurView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        contentView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(605)
        }
        
        animationView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(102)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(278)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37)
            $0.left.right.equalToSuperview().inset(60)
        }
        
        percentLabel.snp.makeConstraints { make in
            make.center.equalTo(animationView.snp.center)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(bottomButton.snp.top)
            $0.left.right.equalToSuperview().inset(22)
            $0.top.equalTo(animationView.snp.bottom)
        }
        
        bottomButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(19)
            $0.height.equalTo(65)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(33)
            $0.top.equalToSuperview().inset(24)
            $0.right.equalToSuperview().inset(24)
        }
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        dismiss(animated: true)
    }
    
    @objc private func bottomButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        Storage.shared.saveDeviceToHistory(model)
        dismiss()
        
        NotificationCenter.default.post(name: .init("updateHistory"), object: nil)
    }
}
