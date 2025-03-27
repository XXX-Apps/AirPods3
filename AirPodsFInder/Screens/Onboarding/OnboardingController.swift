import UIKit
import StoreKit
import SafariServices
import SnapKit
import RxSwift
import ShadowImageButton
import PremiumManager
import Utilities

class OnboardingController: UIViewController {
    
    private let imageView = CustomImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
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
                cornerRadius: 16
            )
        )
        button.add(target: self, action: #selector(nextButtonTapped))
        return button
    }()
    
    private weak var coordinator: OnboardingCoordinator?
    private let model: OnboardingModel
    
    init(model: OnboardingModel, coordinator: OnboardingCoordinator) {
        self.model = model
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
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
        view.backgroundColor = .init(hex: "171313")
        
        imageView.image = model.image
        imageView.aspectFill = true
        imageView.verticalAlignment = .bottom
        view.addSubview(imageView)
        
        titleLabel.text = model.title
        titleLabel.font = .font(weight: .black, size: 30)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.highlightText(model.higlitedText, with: .init(hex: "01D4C9"))
        view.addSubview(titleLabel)
        
        subtitleLabel.text = model.subtitle
        subtitleLabel.font = .font(weight: .semiBold, size: 16)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .init(hex: "AFB0AF")
        view.addSubview(subtitleLabel)
        
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
            
//            if UIScreen.isISmall {
                make.top.equalToSuperview()
//            }
            
            make.bottom.equalTo(nextButton.snp.top).inset(-181)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(subtitleLabel.snp.top).inset(-14)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.top).inset(-26)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            make.leading.trailing.equalToSuperview().inset(26)
            make.height.equalTo(62)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(26)
            make.height.equalTo(18)
        }
    }
    
    private func createBottomButton(title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.init(hex: "AFB0AF"), for: .normal)
        button.titleLabel?.font = .font(weight: .regular, size: Locale().isEnglish ? 14 : 10)
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
