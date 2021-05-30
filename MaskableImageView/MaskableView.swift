//
//
//  MaskableImageView
//
//  Created by Duncan Champney on 5/30/21.
//

import UIKit


class MaskableView: UIView {

    var maskLayer = CALayer()

    override var bounds: CGRect {
        didSet {
            print("Bounds = \(bounds)")
            maskLayer.frame = layer.bounds
            installSampleMask()
        }
    }

    func installSampleMask() {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { (ctx) in
            UIColor.black.setFill()
            ctx.fill(bounds, blendMode: .normal)
            let insetRect = bounds.insetBy(dx: bounds.width / 4, dy: bounds.height/4)
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).setFill()
            ctx.fill(insetRect)
        }
        maskLayer.contents = image.cgImage

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        doInitSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        doInitSetup()
    }

    func doInitSetup() {
        layer.mask = maskLayer
    }

}
