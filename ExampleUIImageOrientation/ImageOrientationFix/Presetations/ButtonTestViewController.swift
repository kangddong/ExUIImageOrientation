//
//  ImageRotateViewController.swift
//  colltest
//
//  Created by dongyeongkang on 2022/08/01.
//

import UIKit

class ImageRotateViewController: UIViewController {
    @IBOutlet weak var testImageview: UIImageView!
    @IBOutlet weak var orientaionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard testImageview.image != nil else { return }
        orientaionLabel.text = testImageview.image?.imageOrientation.description
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func rotateImage(_ sender: UIButton) {
        testImageview.image = testImageview.image?.rotate(degrees: 90)
        orientaionLabel.text = testImageview.image?.imageOrientation.description
    }
}
