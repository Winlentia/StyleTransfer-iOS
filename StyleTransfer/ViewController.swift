//
//  ViewController.swift
//  StyleTransfer
//
//  Created by Winlentia on 2.05.2022.
//

import UIKit
import AVFoundation
import CoreMedia
import Vision
import VideoToolbox

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    let sampleImage = UIImage(named: "selfie")
    let manager = StyleManager()
    @IBOutlet weak var styleCollectionView: UICollectionView!
    @IBOutlet weak var styleCollectionViewFlowLayout: UICollectionViewFlowLayout!
    var styleDataSources: [StyleModels] {
        var array: [StyleModels] = []
        for style in StyleModels.allCases {
            array.append(style)
        }
        return array
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = sampleImage
        
        styleCollectionView.register(.init(nibName: "StyleCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "StyleCellIdentifier")
        let layout = UICollectionViewFlowLayout()
        let height = styleCollectionView.frame.size.height - 10
        layout.itemSize = .init(width: height, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        styleCollectionView.delegate = self
        styleCollectionView.dataSource = self
        styleCollectionView.collectionViewLayout = layout
    }

    @IBAction func styleOnePressed(_ sender: Any) {
        manager.getStyleImage(image: sampleImage!, style: .AbstractTest) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
                
            case .failure(let err):
                print(err)
            }
        }
    }
    
    
    
    @IBAction func originalmage(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(imageView.image!,nil,nil,nil);
        imageView.image = sampleImage
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleDataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = styleCollectionView.dequeueReusableCell(withReuseIdentifier: "StyleCellIdentifier", for: indexPath) as! StyleCollectionViewCell
        cell.setupCell(style: styleDataSources[indexPath.row])
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        manager.getStyleImage(image: self.sampleImage!, style: styleDataSources[indexPath.row]) { result in
            switch result {
            case.success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 120)
    }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.height-5, height: collectionView.bounds.height-5)
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
