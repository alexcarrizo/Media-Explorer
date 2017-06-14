//
//  FlickrImageSize.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/9/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import Foundation

enum FlickrMediaSize: Int, CaseCountable {
    static let count = FlickrMediaSize.countCases()
    
    case original
    case large2048
    case large1600
    case largeSquare
    case large
    case medium800
    case medium640
    case medium
    case small320
    case small
    case square
    case thumbnail
    case mobileMP4
    
    init?(section: Int) {
        switch section {
        case 0: self = .original
        case 1: self = .large2048
        case 2: self = .large1600
        case 3: self = .largeSquare
        case 4: self = .large
        case 5: self = .medium800
        case 6: self = .medium640
        case 7: self = .medium
        case 8: self = .small320
        case 9: self = .small
        case 10: self = .square
        case 11: self = .thumbnail
        case 12: self = .mobileMP4
        default:  return nil
        }
    }
    
    static let mapper: [FlickrMediaSize: String] = [
        .original:      "Original",
        .large2048:     "Large 2048",
        .large1600:     "Large 1600",
        .largeSquare:   "Large Square",
        .large:         "Large",
        .medium800:     "Medium 800",
        .medium640:     "Medium 640",
        .medium:        "Medium",
        .small320:      "Small 320",
        .small:         "Small",
        .square:        "Square",
        .thumbnail:     "Thumbnail",
        .mobileMP4:     "Mobile MP4"
        
    ]
    var string: String {
        return FlickrMediaSize.mapper[self]!
    }
}


