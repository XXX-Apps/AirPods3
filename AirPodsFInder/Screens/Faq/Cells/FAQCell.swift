import UIKit
import SnapKit
import Utilities

final class FAQCell: UITableViewCell {
    
    static let identifier = "FAQCell"
    
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
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 18)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .medium, size: 16)
        label.textColor = .black
        label.numberOfLines = 0
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
        
        contentView.addSubview(rightImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        rightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(40)
            make.centerY.equalTo(titleLabel)
            make.height.width.equalTo(27)
        }
        
        customBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(69)
            make.top.equalToSuperview().inset(35)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(49)
            make.right.equalToSuperview().inset(69)
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    func configure(model: FaqModel, isExpanded: Bool) {

        titleLabel.attributedText = model.title.localized.attributedString(
            font: .font(weight: .semiBold, size: 24),
            aligment: .left,
            color: .init(hex: "#1C1B2A"),
            lineSpacing: 5,
            maxHeight: 50
        )
        
        subtitleLabel.isHidden = !isExpanded
        
        if isExpanded {
            subtitleLabel.attributedText = model.subtitle.localized.attributedString(
                font: .font(weight: .medium, size: 18),
                aligment: .left,
                color: .init(hex: "838DA7"),
                lineSpacing: 5,
                maxHeight: 20
            )
        } else {
            subtitleLabel.text = ""
        }
        
        rightImageView.image = isExpanded ? .arrowTop : .arrowRight
    }
}
