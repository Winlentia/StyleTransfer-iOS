//
//  StyleCollectionViewCell.swift
//  StyleTransfer
//
//  Created by Winlentia on 2.05.2022.
//

import UIKit

class StyleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sampleImage: UIImageView!
    let monaLisa = UIImage(named: "MonaLisa")
    var style: StyleModels = .Gogh1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(style: StyleModels) {
        self.style = style
        let manager = StyleManager()
        manager.getStyleImage(image: monaLisa!, style: style) { result in
            switch result {
            case.success(let image):
                self.sampleImage.image = image
            case.failure(let err):
                print(err)
            }
        }
    }

}
