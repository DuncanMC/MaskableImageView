//
//  ViewController.swift
//  MaskableImageView
//
//  Created by Duncan Champney on 5/30/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var maskableView: MaskableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func handleEraseRevealControl(_ sender: UISegmentedControl) {
        if let drawingAction  = DrawingAction(rawValue: sender.selectedSegmentIndex) {
            maskableView.drawingAction = drawingAction
        }
    }

}

