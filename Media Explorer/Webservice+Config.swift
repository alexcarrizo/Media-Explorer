//
//  Webservice+Config.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/12/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

extension WebService {
    
    struct Config {
        
        struct pixabay {
            static let apiKey = "PixabayAPIKeyGoesHere"
            static let baseUrlImages = "https://pixabay.com/api/"
            static let baseUrlVideos = "https://pixabay.com/api/videos/"
            static let pageSize = 100  //Accepted values: 3 - 200; Default: 20
        }
        
        struct flickr {
            static let apiKey = "FlickrAPIKeyGoesHere"
            static let baseUrl = "https://api.flickr.com/services/rest/"
            static let pageSize = 100  //defaults to 100. The maximum allowed value is 500
        }
    }
}
