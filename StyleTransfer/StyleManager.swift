//
//  StyleManager.swift
//  CreateMLVideoStyleTransfer
//
//  Created by Winlentia on 8.04.2022.
//  Copyright © 2022 Anupam Chugh. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import VideoToolbox
import Vision


struct StyleManager{
    
    private func getMLModelWithConfig(styleModel: StyleModels, computeUnits: MLComputeUnits = .all) -> MLModel? {
        
        let config = MLModelConfiguration()
        config.computeUnits = computeUnits
        
        
        var s : MLModel?
        
        switch styleModel {
//        case .StyleBlue:
//            s = try? StyleBlue.init(configuration: config).model
//        case .BlueStrong:
//            s = try? BlueStrong.init(configuration: config).model
//        case .Hell:
//            s = try? Hell.init(configuration: config).model
//        case .AbstractTest:
//            s = try? AbstractTest.init(configuration: config).model
//        case .RickAndMorty:
//            s = try? RickAndMorty.init(configuration: config).model
        case .Gogh1:
            s = try? gogh1.init(configuration: config).model
        case .Gogh2:
            s = try? gogh2.init(configuration: config).model
        case .Gogh3:
            s = try? gogh3.init(configuration: config).model
        case .PicassoIteration90:
            s = try? PicassoIteration90.init(configuration: config).model
        case .PicassoIteration110:
            s = try? PicassoIteration110.init(configuration: config).model
        case .PicassoIteration130:
            s = try? PicassoIteration130.init(configuration: config).model
        case .PicassoIteration140:
            s = try? PicassoIteration140.init(configuration: config).model
        case .PicassoIteration160:
            s = try? PicassoIteration160.init(configuration: config).model
        case .PicassoIteration190:
            s = try? PicassoIteration190.init(configuration: config).model
        case .PicassoIteration200:
            s = try? PicassoIteration200.init(configuration: config).model
        case .PicassoIteration210:
            s = try? PicassoIteration210.init(configuration: config).model
        case .PicassoIteration220:
            s = try? PicassoIteration220.init(configuration: config).model
        case .PicassoIteration280:
            s = try? PicassoIteration280.init(configuration: config).model
        case .PicassoIteration290:
            s = try? PicassoIteration290.init(configuration: config).model
        case .PicassoIteration300:
            s = try? PicassoIteration300.init(configuration: config).model
        case .PicassoIteration430:
            s = try? PicassoIteration430.init(configuration: config).model
        case .PicassoIteration440:
            s = try? PicassoIteration440.init(configuration: config).model
        case .PicassoIteration450:
            s = try? PicassoIteration450.init(configuration: config).model
        case .PicassoIteration470:
            s = try? PicassoIteration470.init(configuration: config).model
        }
        
        return s
    }
    
    func getStyleImage(image: UIImage, style: StyleModels, completion: @escaping (Result<UIImage,Error>) -> Void){
        guard let styleModel =  self.getMLModelWithConfig(styleModel: style) else {return}

        guard let model = try? VNCoreMLModel(for: styleModel) else { return }
        
        
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let results = finishedRequest.results as? [VNPixelBufferObservation] else { return }

            guard let observation = results.first else { return }

            DispatchQueue.main.async(execute: {
                let styleImage = UIImage(pixelBuffer: observation.pixelBuffer)!
                let croppedImage = styleImage.cropImage()
                completion(.success(croppedImage))
            })
        }
        
        request.imageCropAndScaleOption = .scaleFit
        
        try? VNImageRequestHandler(cgImage: (image.cgImage)!, options: [:]).perform([request])
    }
}

