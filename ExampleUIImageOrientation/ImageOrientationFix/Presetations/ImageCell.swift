//
//  ImageCell.swift
//  colltest
//
//  Created by dongyeongkang on 2022/07/27.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var orientationLabel: UILabel!
    
    override func awakeFromNib() {
        initImageview()
        
    }
    override func layoutSubviews() {
        //initImageview()
    }
    
    //이미지 뷰
    private func initImageview() {
        orientationLabel.text = ""
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.lightGray
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.masksToBounds = true
        image.clipsToBounds = true
        deleteButton.isHidden = true
    }
    
    func configImageView(image: UIImage, hidden: Bool) {
        self.image.image = image
        orientationLabel.text = image.imageOrientation.description
        deleteButton.isHidden = hidden
    }
    
    func configAddView(image: UIImage, hidden: Bool) {
        self.image.image = image
        orientationLabel.text = image.imageOrientation.description
        deleteButton.isHidden = hidden
        self.image.layer.borderWidth = 5.0
        self.image.layer.borderColor = UIColor.red.cgColor
    }
}
