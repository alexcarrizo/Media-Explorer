//
//  MediaCollection.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/8/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import Foundation

final class MediaCollection {
    
    var media = [Any]()
    var mediaSource:MediaSource?
    var pageCurrent = 0
    var pages = 0
    var pageSize = 0
    var totalNumberOfResults = 0
    var query: String?
}
