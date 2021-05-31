//
//  ViewController.swift
//  MaskableImageView
//
//  Created by Duncan Champney on 5/30/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var circleRadiusLabel: UILabel!
    @IBOutlet weak var circleRadiusSlider: UISlider!

    @IBOutlet weak var alphaLabel: UILabel!
    @IBOutlet weak var alphaSlider: UISlider!

    var maskDrawingAlpha: CGFloat = 0 {
        didSet {
            maskableView.maskDrawingAlpha = maskDrawingAlpha
            alphaLabel.text = String(format: "%.2f", maskDrawingAlpha)
            alphaSlider.value = Float(maskDrawingAlpha)
        }
    }
    var circleRadius: CGFloat = 0
    {
       didSet {
        maskableView.circleRadius = circleRadius
        circleRadiusLabel.text = String(format: "%.1f", circleRadius)
        circleRadiusSlider.value = Float(circleRadius)
       }
   }

    @IBOutlet weak var maskableView: MaskableView!

    var maskableViewBounds = CGRect.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleEraseRevealControl(_ sender: UISegmentedControl) {
        if let drawingAction  = DrawingAction(rawValue: sender.selectedSegmentIndex) {
            maskableView.drawingAction = drawingAction
        }
    }
    @IBAction func handleCircleRadiusSlider(_ sender: UISlider) {
         circleRadius = CGFloat(sender.value)
    }

    @IBAction func handleAlphaSlider(_ sender: UISlider) {
        maskDrawingAlpha = CGFloat(sender.value)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleRadius = 20
        maskDrawingAlpha = 0.5
    }

    override func viewDidLayoutSubviews() {
        if maskableView.bounds != maskableViewBounds {
            maskableViewBounds = maskableView.bounds
            maskableView.updateBounds()
        }
    }
}

