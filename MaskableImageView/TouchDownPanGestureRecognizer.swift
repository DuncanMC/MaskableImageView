//
//  TouchDownPanGestureRecognizer.swift
//  MaskableImageView
//
//  Created by Duncan Champney on 5/31/21.
//

import UIKit

/// This is a simple subclass of UIPanGestureRecognizer that begins sending notifications when the user first touches down
/// rather than waiting until they begin dragging.
class TouchDownPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        state = .began
    }
}
