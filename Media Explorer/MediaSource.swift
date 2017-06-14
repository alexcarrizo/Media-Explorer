//
//  MediaSource.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/4/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//


enum MediaSource: Int, CaseCountable {
    static let count = MediaSource.countCases()

    case pixabayImages
    case pixabayVideos
    case flickrImages
    case flickrVideos
    
    init?(section: Int) {
        switch section {
        case 0: self = .pixabayImages
        case 1: self = .pixabayVideos
        case 2: self = .flickrImages
        case 3: self = .flickrVideos
        default:  return nil
        }
    }
}
