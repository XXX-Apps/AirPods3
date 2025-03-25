import UIKit
import SnapKit
import ShadowImageButton
import Utilities

final class HistoryCell: UITableViewCell {
    
    static let identifier = "HistoryCell"
    
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
        imageView.layer.shadowOpacity = 0.1
        imageView.layer.shadowOffset = .init(width: 0, height: 2)
        imageView.layer.shadowRadius = 21.5
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .chevronLeft
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 18)
        label.numberOfLines = 0
        label.text = "No devices found".localized
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .medium, size: 16)
        label.textColor = .init(hex: "#9DA0B3")
        return label
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
        
        customBackgroundView.addSubview(centerImageView)
        customBackgroundView.addSubview(titleLabel)
        customBackgroundView.addSubview(subtitleLabel)
        customBackgroundView.addSubview(rightImageView)

        centerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(43)
            make.left.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }

        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(22)
            make.top.equalToSuperview().inset(9.5)
            make.bottom.equalToSuperview().inset(9.5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.left.equalToSuperview().inset(74)
            make.right.equalToSuperview().inset(60)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(74)
            make.right.equalToSuperview().inset(60)
        }
        
        rightImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.right.equalToSuperview().inset(24)
        }
    }
    
    func configure(model: HistoryModel) {
        
        titleLabel.text = model.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy"
        
        subtitleLabel.text = dateFormatter.string(from: model.date)
        
        centerImageView.image = model.type.image
    }
}

