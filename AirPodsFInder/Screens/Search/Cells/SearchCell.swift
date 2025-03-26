import UIKit
import SnapKit
import ShadowImageButton
import Utilities
import Lottie

final class SearchCell: UITableViewCell {
    
    static let identifier = "SearchCell"

    private lazy var animationView: LottieAnimationView = {
        let path = Bundle.main.path(
            forResource: "Search device",
            ofType: "json"
        ) ?? ""
        let animationView = LottieAnimationView(filePath: path)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        animationView.play()
        return animationView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .font(weight: .bold, size: 22)
        label.numberOfLines = 0
        label.text = "Looking for devices...".localized
        label.textColor = .white
        label.textAlignment = .center
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

        contentView.addSubview(animationView)
        contentView.addSubview(titleLabel)

        animationView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(70)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

