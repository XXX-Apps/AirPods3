import UIKit
import SnapKit
import ShadowImageButton
import Utilities

final class EmptyHistoryCell: UITableViewCell {
    
    static let identifier = "EmptyHistoryCell"
    
    private lazy var customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .init(width: 0, height: 3)
        view.layer.shadowRadius = 9
        view.layer.masksToBounds = false
        return view
    }()

    private let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .empty
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.08
        imageView.layer.shadowOffset = .init(width: 0, height: 4)
        imageView.layer.shadowRadius = 25.5
        imageView.layer.masksToBounds = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .semiBold, size: 22)
        label.textColor = .init(hex: "#9DA0B3")
        label.numberOfLines = 0
        label.text = "No devices found".localized
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [centerImageView, titleLabel])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 10
        return view
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

        customBackgroundView.addSubview(stackView)

        centerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(54)
        }

        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

