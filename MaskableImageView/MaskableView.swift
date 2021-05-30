//
//
//  MaskableImageView
//
//  Created by Duncan Champney on 5/30/21.
//

import UIKit

enum DrawingAction: Int {
    case erase = 0
    case draw = 1
}

class MaskableView: UIView {

    public var drawingAction: DrawingAction = .erase
    public var circleRadius: CGFloat = 20
    var maskImage: UIImage? = nil

    private var maskLayer = CALayer()
    private var renderer: UIGraphicsImageRenderer?
    private var gestureRecognizer = UIPanGestureRecognizer()

    override var bounds: CGRect {
        didSet {
            print("Bounds = \(bounds)")
            maskLayer.frame = layer.bounds
            renderer = UIGraphicsImageRenderer(size: bounds.size)
            installSampleMask()
        }
    }


    func installSampleMask() {
        guard let renderer = renderer else { return }
        let image = renderer.image { (ctx) in
            UIColor.black.setFill()
            ctx.fill(bounds, blendMode: .normal)
            let insetRect = bounds.insetBy(dx: bounds.width / 4, dy: bounds.height/4)
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).setFill()
            ctx.fill(insetRect)
        }
        maskImage = image
        maskLayer.contents = maskImage?.cgImage

    }

    func drawCircleAtPoint(point: CGPoint) {
        guard let renderer = renderer else { return }
        let image = renderer.image { (context) in
            if let maskImage = maskImage {
                maskImage.draw(in: bounds)
                 let rect = CGRect(origin: point, size: CGSize.zero).insetBy(dx: -circleRadius/2, dy: -circleRadius/2)
                let color = UIColor.black.cgColor
                context.cgContext.setFillColor(color)
                let blendMode: CGBlendMode = drawingAction == .erase ? .clear : .normal
                UIBezierPath(ovalIn:rect).fill(with: blendMode, alpha: 1.0)
            }
        }
        maskImage = image
        maskLayer.contents = maskImage?.cgImage
    }

    @IBAction func didDrag(_ sender: UIPanGestureRecognizer) {
        let point = sender.location(in: self)
        drawCircleAtPoint(point: point)
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
        self.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(didDrag(_:)))
    }

}

extension MaskableView: UIGestureRecognizerDelegate {

}
