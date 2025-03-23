import UIKit

final class IconCell: UICollectionViewCell {
    
    static let identifier = "IconCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.layer.cornerRadius = 24
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with icon: UIImage?, isSelected: Bool) {
        
        imageView.image = icon
        
        contentView.layer.borderColor = isSelected ? UIColor.black.cgColor : UIColor.clear.cgColor
        contentView.layer.borderWidth = isSelected ? 5 : 0
    }
}
