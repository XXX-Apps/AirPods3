import UIKit
import SnapKit
import ShadowImageButton
import Utilities

final class BluetoothCell: UITableViewCell {
    
    var onAction: (() -> Void)?
    
    static let identifier = "BluetoothCell"
    
    private lazy var customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.14)
        view.layer.cornerRadius = 32
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.init(hex: "#0077FF").cgColor
        view.layer.shadowOpacity = 0.44
        view.layer.shadowOffset = .init(width: 0, height: 10.5)
        view.layer.shadowRadius = 16
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = .gradient
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 28
        view.clipsToBounds = true
        return view
    }()
    
    private let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .bluetoothOff
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.08
        imageView.layer.shadowOffset = .init(width: 0, height: 4)
        imageView.layer.shadowRadius = 25.5
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .medium, size: 20)
        label.textColor = .white.withAlphaComponent(0.64)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bottomButton: ShadowImageButton = {
        let button = ShadowImageButton()
        button.configure(
            buttonConfig: .init(
                title: "Start now".localized,
                font: .font(
                    weight: .semiBold,
                    size: 18
                ),
                textColor: .init(hex: "#1C1B2A"),
                image: nil
            ),
            backgroundImageConfig: .init(
                image: nil,
                cornerRadius: 10,
                shadowConfig: .init(
                    color: .white,
                    opacity: 0.25,
                    offset: .init(width: 0, height: 4),
                    radius: 10
                )
            )
        )
        button.backgroundColor = .white
        button.action = { [weak self] in
            self?.onAction?()
        }
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
        customBackgroundView.addSubview(centerImageView)
        customBackgroundView.addSubview(titleLabel)
        customBackgroundView.addSubview(subtitleLabel)
        customBackgroundView.addSubview(bottomButton)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        centerImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(19)
            make.height.width.equalTo(102)
        }
        
        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(28)
            make.bottom.equalToSuperview().inset(26)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(38)
            make.top.equalToSuperview().inset(134)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(38)
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
        }
        
        bottomButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(53)
            make.width.equalTo(170)
        }
    }
    
    func confgiure(isOn: Bool) {
        centerImageView.image = isOn ? UIImage(named: "bluetoothOn") : UIImage(named: "bluetoothOff")
        titleLabel.text = isOn ? "Bluetooth is active".localized : "Turn on Bluetooth".localized
        subtitleLabel.text = isOn ? "your device is ready to search".localized : "to start search for devices".localized
        bottomButton.updateTitle(title: isOn ? "Start search".localized : "Go to Settings".localized)
    }
}

