import UIKit
import StoreKit
import SafariServices
import SnapKit
import RxSwift
import ShadowImageButton
import PremiumManager
import Utilities

class OnboardingController: UIViewController {
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .onboardingBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var shadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .onboardingShadow
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let imageView = CustomImageView()
    private let titleLabel = UILabel()
    private let bottomStackView = UIStackView()
    
    private let disposeBag = DisposeBag()
    
    private lazy var nextButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Continue".localized,
                font: .font(
                    weight: .bold,
                    size: 18
                ),
                textColor: .white,
                image: nil
            ),
            backgroundImageConfig: .init(
                image: .gradient,
                cornerRadius: 16,
                shadowConfig: .init(
                    color: .init(hex: "0077FF"),
                    opacity: 0.44,
                    offset: .init(width: 0, height: 10.5),
                    radius: 18
                )
            )
        )
        button.action = { [weak self] in
            self?.nextButtonTapped()
        }
        return button
    }()
    
    private weak var coordinator: OnboardingCoordinator?
    private let model: OnboardingModel
    
    init(model: OnboardingModel, coordinator: OnboardingCoordinator, shadowImage: UIImage = .onboardingShadow1) {
        self.model = model
        self.coordinator = coordinator
     
        super.init(nibName: nil, bundle: nil)
        
        self.shadowImageView.image = shadowImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        PremiumManager.shared.isPremium
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { isPremium in
                if isPremium {
                    self.close()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        
        imageView.image = model.image
        imageView.aspectFill = false
        imageView.verticalAlignment = .bottom
        view.addSubview(imageView)
        
        view.addSubview(shadowImageView)
        
        let attributedString = NSMutableAttributedString(attributedString: model.title.attributedString(
            font: .font(weight: .bold, size: UIScreen.isBigDevice ? 34 : 32),
            aligment: .center,
            color: .init(hex: "#181818"),
            lineSpacing: 5,
            maxHeight: 30
        ))
        
        
        let range = (model.title as NSString).range(of: model.higlitedText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hex: "#0163F8"), range: range)
        
        titleLabel.attributedText = attributedString
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        view.addSubview(nextButton)
        
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.spacing = 16
        
        let privacyButton = createBottomButton(title: "Privacy".localized)
        let restoreButton = createBottomButton(title: "Restore".localized)
        let termsButton = createBottomButton(title: "Terms".localized)
        
        privacyButton.addTarget(self, action: #selector(openPrivacy), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(restore), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(openTerms), for: .touchUpInside)
        
        bottomStackView.addArrangedSubview(privacyButton)
        bottomStackView.addArrangedSubview(restoreButton)
        bottomStackView.addArrangedSubview(termsButton)
        
        view.addSubview(bottomStackView)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(UIScreen.isLittleDevice ? 157 : 187)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-54)
            make.leading.trailing.equalToSuperview().inset(22)
            make.height.equalTo(69)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(26)
            make.height.equalTo(18)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(137)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        shadowImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(149)
            make.bottom.equalTo(nextButton.snp.top)
        }
    }
    
    private func createBottomButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.init(hex: "#99A5C3"), for: .normal)
        button.titleLabel?.font = .font(weight: .medium, size: Locale().isEnglish ? 14 : 10)
        return button
    }
    
    @objc private func nextButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        if model.rating {
            SKStoreReviewController.requestReview()
        }
        coordinator?.goToNextScreen()
    }
    
    @objc private func openPrivacy() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let url = URL(string: Config.privacy) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc private func openTerms() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        if let url = URL(string: Config.terms) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc private func restore() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        PremiumManager.shared.restorePurchases()
    }
    
    @objc private func close() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        replaceRootViewController(with: UINavigationController(rootViewController: HomeController()))
    }
}
