//
//
//  MaskableView
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
    public var maskDrawingAlpha: CGFloat = 1.0
    var maskImage: UIImage? = nil

    private var maskLayer = CALayer()
    private var renderer: UIGraphicsImageRenderer?
    private var panGestureRecognizer = UIPanGestureRecognizer()
    private var tapGestureRecognizer = UITapGestureRecognizer()

    public func updateBounds() {
        maskLayer.frame = layer.bounds
        installSampleMask()
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
                let blendMode: CGBlendMode
                let alpha: CGFloat
                if drawingAction == .erase {
                    // This is what I worked out to reduce the alpha of the mask by maskDrawingAlpha in the drawing area
                    blendMode = .sourceIn
                    alpha = 1 - maskDrawingAlpha
                } else {
                    // In normal drawing mode the new drawing alpha is added to the alpha of the existing area.
                    blendMode = .normal
                    alpha = maskDrawingAlpha
                }
                UIBezierPath(ovalIn:rect).fill(with: blendMode, alpha: alpha)
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
        renderer = UIGraphicsImageRenderer(size: bounds.size)
        layer.mask = maskLayer
        self.addGestureRecognizer(panGestureRecognizer)
        self.addGestureRecognizer(tapGestureRecognizer)
        panGestureRecognizer.addTarget(self, action: #selector(didDrag(_:)))
        tapGestureRecognizer.addTarget(self, action: #selector(didDrag(_:)))
    }
}
