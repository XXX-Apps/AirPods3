import UIKit
import SnapKit

final class SettingsCell: UITableViewCell {
    
    static let identifier = "SettingsCell"
    
    private lazy var customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 18
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .init(width: 0, height: 3)
        view.layer.shadowRadius = 9
        view.layer.masksToBounds = false
        return view
    }()
    
    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 18)
        label.textColor = .black
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
        
        customBackgroundView.addSubview(leftImageView)
        customBackgroundView.addSubview(titleLabel)
        
        leftImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(28)
        }
        
        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(68)
            make.right.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(model: SettingsType) {
        titleLabel.text = model.title
        leftImageView.image = model.image
    }
}
