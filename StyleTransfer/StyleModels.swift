//
//  Style.swift
//  CreateMLVideoStyleTransfer
//
//  Created by Winlentia on 8.04.2022.
//  Copyright © 2022 Anupam Chugh. All rights reserved.
//

import Foundation


enum StyleModels: String, CaseIterable {
//    case BlueStrong
//    case StyleBlue
    case Hell
    case AbstractTest
    case RickAndMorty
    case Gogh1
    case Gogh2
    case Gogh3
    case PicassoIteration90
    case PicassoIteration110
    case PicassoIteration130
    case PicassoIteration140
    case PicassoIteration160
    case PicassoIteration190
    case PicassoIteration200
    case PicassoIteration210
    case PicassoIteration220
    case PicassoIteration280
    case PicassoIteration290
    case PicassoIteration300
    case PicassoIteration430
    case PicassoIteration440
    case PicassoIteration450
    case PicassoIteration470
    case BrownTone
    case ResizeGan
    case Leons
    case YellowArtistic
}

extension StyleModels {
    static func getArtisticStyles() -> [StyleModels] {
        var artisticStyles:[StyleModels] = []
        artisticStyles.append(.BrownTone)
        artisticStyles.append(.Hell)
        artisticStyles.append(.RickAndMorty)
        artisticStyles.append(.AbstractTest)
        artisticStyles.append(.Leons)
        artisticStyles.append(.YellowArtistic)
        
        return artisticStyles
    }
    
    static func getNormalStyles() -> [StyleModels] {
        var array: [StyleModels] = []
        let artisticStyles = self.getArtisticStyles()
        for style in StyleModels.allCases {
            if !artisticStyles.contains(style) && style != ResizeGan{
                array.append(style)
            }
        }
        return array
    }
}






