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
import KRProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var styleCollectionView: UICollectionView!
    @IBOutlet weak var artisticStyleCollectionView: UICollectionView!
    @IBOutlet weak var styleCollectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var selectImageLabel: UILabel!
    
    
    var selectedImage: UIImage? {
        didSet {
            self.selectImageLabel.isHidden = true
            
        }
    }
    let sampleImage = UIImage(named: "MonaLisa")
    let manager = StyleManager()
    var isImageStylized: Bool = false
    var imagePicker: ImagePicker!
    
    
    let styleDataSources: [StyleModels] = StyleModels.getNormalStyles()
    let artisticStyleDataSources: [StyleModels] = StyleModels.getArtisticStyles()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.contentMode = .scaleAspectFit
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setupCollectionView()
    }
    

    
    fileprivate func setupCollectionView() {
        setupStyleCollectionView()
        setupArtisticStyleCollectionView()
    }
    
    fileprivate func setupStyleCollectionView() {
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
    
    fileprivate func setupArtisticStyleCollectionView() {
        artisticStyleCollectionView.register(.init(nibName: "StyleCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "StyleCellIdentifier")
        let layout = UICollectionViewFlowLayout()
        let height = artisticStyleCollectionView.frame.size.height - 10
        layout.itemSize = .init(width: height, height: height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        artisticStyleCollectionView.delegate = self
        artisticStyleCollectionView.dataSource = self
        artisticStyleCollectionView.collectionViewLayout = layout
    }
    
    @IBAction func selectImage(_ sender: Any) {
        self.imagePicker.present(from: self.view!)
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        
        if let image = selectedImage {
            imageView.image = image
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        KRProgressHUD.show(withMessage: "Loading")
        if let image = imageView.image {
            manager.scaleUpImage(image: image) { result in
                switch result {
                case .success(let scaledImage):
                    UIImageWriteToSavedPhotosAlbum(scaledImage, nil, nil, nil)
                    KRProgressHUD.dismiss {
                        KRProgressHUD.showMessage("Saved Successfully")
                    }
                case .failure(let err):
                    KRProgressHUD.dismiss {
                        KRProgressHUD.showMessage("Failed \(err.localizedDescription)")
                    }
                }
            }
            // create the alert
                   
        }
    }
    @IBAction func originalmage(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(imageView.image!,nil,nil,nil);
        imageView.image = sampleImage
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.styleCollectionView {
            return styleDataSources.count
        } else {
            return artisticStyleDataSources.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = styleCollectionView.dequeueReusableCell(withReuseIdentifier: "StyleCellIdentifier", for: indexPath) as! StyleCollectionViewCell
        if collectionView === self.styleCollectionView {
            cell.setupCell(style: styleDataSources[indexPath.row])
        } else {
            cell.setupCell(style: artisticStyleDataSources[indexPath.row])
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = self.selectedImage {
            var style: StyleModels = .RickAndMorty
            if collectionView === self.styleCollectionView {
                style = styleDataSources[indexPath.row]
            } else {
                style = artisticStyleDataSources[indexPath.row]
            }
            manager.getStyleImage(image: image, style: style) { result in
                switch result {
                case.success(let styleImage):
                    self.imageView.image = styleImage
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            // show popup select Image
            
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


extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?){
        selectedImage = image
        imageView.image = selectedImage
    }
}
