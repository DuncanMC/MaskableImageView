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

import UIKit.UIGestureRecognizerSubclass


class MaskableView: UIView {

    public var drawingAction: DrawingAction = .erase
    public var circleRadius: CGFloat = 20
    public var maskDrawingAlpha: CGFloat = 1.0

    /// This color is used to draw the "cursor" around the circle shape being drawn onto the mask layer. By default the color is clear (no cursor)
    /// Set a color if you want to stroke the circle being drawn.
    public var circleCursorColor = UIColor.clear {
        didSet { shapeLayer.strokeColor = circleCursorColor.cgColor }
    }

    // MARK: - Private vars

    private var maskImage: UIImage? = nil
    private var maskLayer = CALayer()
    private var shapeLayer = CAShapeLayer()
    private var renderer: UIGraphicsImageRenderer?
    private var panGestureRecognizer = TouchDownPanGestureRecognizer()

    private var firstTime = true

    // MARK: - Public functions

    public func updateBounds() {
        maskLayer.frame = layer.bounds
        shapeLayer.frame = layer.frame
        if firstTime {
            installSampleMask()
            layer.superlayer?.addSublayer(shapeLayer)
            firstTime = false
        } else {
            guard let renderer = renderer else { return }
            let image = renderer.image { (context) in
                if let maskImage = maskImage {
                    maskImage.draw(in: bounds)
                }
            }
            maskImage = image
            maskLayer.contents = maskImage?.cgImage

        }
    }

    private func installSampleMask() {
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

    private func drawCircleAtPoint(point: CGPoint) {
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
                let circlePath = UIBezierPath(ovalIn:rect)
                circlePath.fill(with: blendMode, alpha: alpha)
                shapeLayer.path = circlePath.cgPath
            }
        }
        maskImage = image
        maskLayer.contents = maskImage?.cgImage
    }

    // MARK: - IBAction methods

    // Erase/un-erase the point from the tap/pan gesture recognzier
    @IBAction func gestureRecognizerUpdate(_ sender: UIGestureRecognizer) {
        let point = sender.location(in: self)
        drawCircleAtPoint(point: point)
        if sender.state == .ended {
            self.shapeLayer.path = nil
        }
    }

    // MARK: - Object lifecycle methods

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
        shapeLayer.strokeColor = circleCursorColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.clear.cgColor

        // Set up a pan gesture recognizer to erase/un-erase a series of circles as the user drags over the image.
        panGestureRecognizer.addTarget(self, action: #selector(gestureRecognizerUpdate(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
}
