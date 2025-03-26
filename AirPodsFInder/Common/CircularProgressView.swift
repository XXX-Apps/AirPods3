import UIKit

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var trackLayer = CAShapeLayer()
    fileprivate var didConfigureLabel = false
    fileprivate var rounded: Bool
    fileprivate var filled: Bool
    
    fileprivate let lineWidth: CGFloat?
    
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
            setProgress(to: progress, animated: false)
        }
    }

    fileprivate func createProgressView() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.size.width / 2
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: frame.width / 2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = .none
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = filled ? frame.width : lineWidth!
        trackLayer.lineCap = filled ? .butt : .round
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = .none
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = filled ? frame.width : lineWidth!
        progressLayer.lineCap = rounded ? .round : .butt
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
    }
    
    func setProgress(to newProgress: Float, animated: Bool = false) {
        if animated {
            progressLayer.strokeEnd = CGFloat(newProgress)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            progressLayer.strokeEnd = CGFloat(newProgress)
            CATransaction.commit()
        }
    }
    
    func trackColorToProgressColor() {
        trackColor = UIColor(red: progressColor.cgColor.components![0],
                           green: progressColor.cgColor.components![1],
                           blue: progressColor.cgColor.components![2],
                           alpha: 0.2)
    }
    
    override init(frame: CGRect) {
        progress = 0
        rounded = true
        filled = false
        lineWidth = 15
        super.init(frame: frame)
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
        self.rounded = lineWidth == nil ? false : rounded
        self.filled = lineWidth == nil
        self.lineWidth = lineWidth
        super.init(frame: frame)
        createProgressView()
    }
}
