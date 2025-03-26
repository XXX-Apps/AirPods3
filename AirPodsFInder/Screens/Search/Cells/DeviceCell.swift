import UIKit
import SnapKit
import ShadowImageButton
import Utilities

final class DeviceCell: UITableViewCell {
    
    static let identifier = "DeviceCell"
    
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
    
    private let signalImageView: UIImageView = {
        let imageView = UIImageView()
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
    
    private let progressView = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 43, height: 43), lineWidth: 2, rounded: true)
    
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
        customBackgroundView.addSubview(signalImageView)
        customBackgroundView.addSubview(progressView)
        
        progressView.progressColor = .init(hex: "00A6FF")
        progressView.trackColor = .clear
                
        centerImageView.snp.makeConstraints { make in
            make.height.width.equalTo(43)
            make.left.equalToSuperview().inset(19)
            make.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.edges.equalTo(centerImageView)
        }
        
        signalImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(61)
            make.height.equalTo(23)
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
    
    func configure(model: DeviceModel) {
        
        titleLabel.text = model.name
        
        subtitleLabel.text = String(format: "%.1f m", model.distance)
        
        centerImageView.image = model.type.image
        
        updateSignalStrength(model.distance)
        
        progressView.progress = 0.6
    }
    
    func updateSignalStrength(_ distance: Double) {
        switch distance {
        case 0:
            signalImageView.image = .signal4
        case 1:
            signalImageView.image = .signal4
        case 2:
            signalImageView.image = .signal4
        default:
            signalImageView.image = .signal4
        }
    }
}

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var didConfigureLabel = false
    fileprivate var rounded: Bool
    fileprivate var filled: Bool
    
    fileprivate let lineWidth: CGFloat?

    var timeToFill = 3.43
    
    var progressColor = UIColor.white {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor = UIColor.white {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    var progress: Float {
        didSet {
            var pathMoved = progress - oldValue
            if pathMoved < 0 {
                pathMoved = 0 - pathMoved
            }
            setProgress(duration: timeToFill * Double(pathMoved), to: progress)
        }
    }

    fileprivate func createProgressView() {
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.size.width / 2
        let circularPath = UIBezierPath(arcCenter: center, radius: frame.width / 2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.fillColor = UIColor.blue.cgColor
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = trackColor.cgColor
        if filled {
            trackLayer.lineCap = .butt
            trackLayer.lineWidth = frame.width
        } else {
            trackLayer.lineWidth = lineWidth!
        }
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = .none
        progressLayer.strokeColor = progressColor.cgColor
        if filled {
            progressLayer.lineCap = .butt
            progressLayer.lineWidth = frame.width
        } else {
            progressLayer.lineWidth = lineWidth!
        }
        progressLayer.strokeEnd = 0
        if rounded {
            progressLayer.lineCap = .round
        }
        
        layer.addSublayer(progressLayer)
    }
    
    func trackColorToProgressColor() -> Void {
        trackColor = progressColor
        trackColor = UIColor(red: progressColor.cgColor.components![0], green: progressColor.cgColor.components![1], blue: progressColor.cgColor.components![2], alpha: 0.2)
    }
    
    func setProgress(duration: TimeInterval = 3, to newProgress: Float) -> Void {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = newProgress
        
        progressLayer.strokeEnd = CGFloat(newProgress)
        
        progressLayer.add(animation, forKey: "animationProgress")
    }
    
    override init(frame: CGRect) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(frame: frame)
        filled = false
        createProgressView()
    }
    
    required init?(coder: NSCoder) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(coder: coder)
        createProgressView()
    }
    
    init(frame: CGRect, lineWidth: CGFloat?, rounded: Bool) {
        
        progress = 0
        
        if lineWidth == nil {
            self.filled = true
            self.rounded = false
        } else {
            if rounded{
                self.rounded = true
            } else {
                self.rounded = false
            }
            self.filled = false
        }
        self.lineWidth = lineWidth
        
        super.init(frame: frame)
        createProgressView()
    }
}
