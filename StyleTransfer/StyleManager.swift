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
        case .StyleBlue:
            s = try? StyleBlue.init(configuration: config).model
        case .BlueStrong:
            s = try? BlueStrong.init(configuration: config).model
        case .Hell:
            s = try? Hell.init(configuration: config).model
        case .AbstractTest:
            s = try? AbstractTest.init(configuration: config).model
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
                completion(.success(UIImage(pixelBuffer: observation.pixelBuffer)!))
            })
        }
        
        try? VNImageRequestHandler(cgImage: (image.cgImage)!, options: [:]).perform([request])
    }
}

