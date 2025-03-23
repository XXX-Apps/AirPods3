import UIKit
import SnapKit
import ShadowImageButton
import Utilities

final class SettingsPremiumCell: UITableViewCell {
    
    static let identifier = "SettingsPremiumCell"
    
    private lazy var customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.14)
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.init(hex: "#0077FF").cgColor
        view.layer.shadowOpacity = 0.44
        view.layer.shadowOffset = .init(width: 0, height: 10.5)
        view.layer.shadowRadius = 14
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = .settingsGradient
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        return view
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .premiumCell
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 26)
        label.textColor = .white
        label.text = "AirPods finder PRO".localized
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .medium, size: 16)
        label.textColor = .init(hex: "ABDFFF")
        label.text = "Access all features".localized
        return label
    }()
    
    private let bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Start now".localized,
                font: .font(
                    weight: .bold,
                    size: 18
                ),
                textColor: .black,
                image: nil
            ),
            backgroundImageConfig: .init(
                image: nil,
                cornerRadius: 10,
                shadowConfig: .init(
                    color: .black,
                    opacity: 0.25,
                    offset: .init(width: 0, height: 4),
                    radius: 10
                )
            )
        )
        button.backgroundColor = .white
        button.isUserInteractionEnabled = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(customBackgroundView)
        
        customBackgroundView.addSubview(backgroundImage)
        customBackgroundView.addSubview(rightImageView)
        customBackgroundView.addSubview(titleLabel)
        customBackgroundView.addSubview(subtitleLabel)
        customBackgroundView.addSubview(bottomButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(23)
            make.top.equalToSuperview().inset(24)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(22)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(25)
            make.left.equalToSuperview().inset(23)
            make.height.equalTo(33)
            make.width.equalTo(113)
        }
    }
}

