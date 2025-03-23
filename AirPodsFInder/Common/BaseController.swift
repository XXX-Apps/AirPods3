import UIKit
import SnapKit
import CustomNavigationView
import Utilities

class BaseController: UIViewController {
    
    lazy var topView: CustomNavigationView = {
        let view = CustomNavigationView(
            config: .init(
                containerInsets: .init(
                    top: 0,
                    left: 22,
                    bottom: 0,
                    right: 22
                )
            )
        )
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupView()
        setupConstraints()
    }
    
    func configurNavigation(
        leftView: UIView? = nil,
        centerView: UIView? = nil,
        rightView: UIView? = nil
    ) {
        topView.leftView = leftView
        topView.centerView = centerView
        topView.rightView = rightView
    }
    
    func setupView() {
        view.backgroundColor = UIColor.init(hex: "#FAFCFF")
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(topView)
    }
    
    func setupConstraints() {
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
}
