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
    let sampleImage = UIImage(named: "MonaLisa")
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
        styleCollectionViewFlowLayout.scrollDirection = .horizontal
        styleCollectionView.collectionViewLayout = styleCollectionViewFlowLayout
        styleCollectionView.delegate = self
        styleCollectionView.dataSource = self
        styleCollectionViewFlowLayout.itemSize = .init(width: 180, height: 120)
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
        UIImageWriteToSavedPhotosAlbum(imageView.image!,nil,nil,nil);
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
        manager.getStyleImage(image: self.imageView.image!, style: styleDataSources[indexPath.row]) { result in
            switch result {
            case.success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
}
