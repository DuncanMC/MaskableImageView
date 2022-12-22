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

    @IBAction func handleSaveButton(_ sender: UIButton) {
        print("In handleSaveButton")
        if let image = maskableView.image,
           let pngData = image.pngData(){
            print(image.description)
            let imageURL = getDocumentsDirectory().appendingPathComponent("image.png", isDirectory: false)
            do {
                try pngData.write(to: imageURL)
                print("Wrote png to \(imageURL.path)")
            }
            catch {
                print("Error writing file to \(imageURL.path)")
            }
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleRadius = 20
        maskDrawingAlpha = 0.5
        maskableView.circleCursorColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.8)
        maskableView.outerCircleCursorColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }

    override func viewDidLayoutSubviews() {
        if maskableView.bounds != maskableViewBounds {
            maskableViewBounds = maskableView.bounds
            maskableView.updateBounds()
        }
    }
}

