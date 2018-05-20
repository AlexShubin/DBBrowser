//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let _fromLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _setupUI()
    }
    
    private func _setupUI() {
        view.backgroundColor = .white
        
        // Sheet view
        let sheetView = UIView()
        sheetView.layer.cornerRadius = 24
        sheetView.backgroundColor = .white
        view.addSubview(sheetView)
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        // Stack view
        let stack = UIStackView(arrangedSubviews: [_fromLabel])
        stack.axis = .vertical
        stack.spacing = 8
        sheetView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 24),
            stack.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor, constant: -24),
            stack.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -24)
            ])
        
        // Image view
        let imageView = UIImageView(image: UIImage(asset: Asset.mainScreenImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: sheetView.topAnchor, constant: 24)
            ])
        
        // Views in stack
        _fromLabel.font = UIFont.systemFont(ofSize: 36, weight: .medium)
        _fromLabel.isUserInteractionEnabled = true
        _fromLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        view.bringSubview(toFront: sheetView)
    }
    
}
