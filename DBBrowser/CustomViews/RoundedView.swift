//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    public var roundedCorners: UIRectCorner = []
    public var cornerRadius: CGFloat = 0

    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var _shapeLayer: CAShapeLayer {
        //swiftlint:disable force_cast
        return layer as! CAShapeLayer
        //swiftlint:enable force_cast
    }

    override var backgroundColor: UIColor? {
        get {
            if let cgColor = _shapeLayer.fillColor {
                return UIColor(cgColor: cgColor)
            }
            return nil
        }
        set {
            _shapeLayer.fillColor = newValue?.cgColor
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init() {
        super.init(frame: .zero)
        isOpaque = false
    }

    override public func draw(_ rect: CGRect) {
        guard cornerRadius > 0 else {
            return
        }
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: roundedCorners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        _shapeLayer.path = path
        _shapeLayer.needsDisplayOnBoundsChange = true
    }

}
