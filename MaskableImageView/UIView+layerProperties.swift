//
//  UIView+borderColor.swift
//  AnimatePaths
//
//  Created by Duncan Champney on 5/13/21.
//

import Foundation
import UIKit

/**
 This extension exposes several properties of a UIView's backing CALayer as IBInspectable so they can be set in Storyboards.
 The `borderColor` var exposes the view's layer's borderColor as a UIColor rather than a CGColor, since Interface builder doesn't allow you to specify CGColors
 */
extension UIView {
    @IBInspectable @objc var borderColor: UIColor? {
        get { return layer.borderColor.map { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    @IBInspectable @objc var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable @objc var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    //cornerRadius
}
