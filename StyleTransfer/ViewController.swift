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
    @IBOutlet weak var styleCollectionView: UICollectionView!
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
        
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
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
    
    @IBAction func selectImage(_ sender: Any) {
        self.imagePicker.present(from: self.view!)
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        
        if let image = selectedImage {
            imageView.image = image
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        if let image = imageView.image {
             UIImageWriteToSavedPhotosAlbum(image,nil,nil,nil);
            // create the alert
            let alert = UIAlertController(title: "Success", message: "StyleImage saved to your Photos", preferredStyle: UIAlertController.Style.alert)

            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            // show the alert
            self.present(alert, animated: true, completion: nil)
       
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
        if let image = self.selectedImage {
            manager.getStyleImage(image: image, style: styleDataSources[indexPath.row]) { result in
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
