//
//  WebService+RequestBuilder.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/10/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

extension WebService {
    
    func buildRequestForListOfPhotoUrls(query: String, mediaSource: MediaSource, page: Int) -> (String, Dictionary<String, String>) {
        var baseURL = ""
        var parameters = Dictionary<String, String>()
        
        switch mediaSource {
        case .pixabayImages, .pixabayVideos:
            baseURL = (mediaSource == .pixabayImages) ? Config.pixabay.baseUrlImages : Config.pixabay.baseUrlVideos
            
            parameters["key"] = Config.pixabay.apiKey
            parameters["safesearch"] = "true"
            parameters["orientation"] = "horizontal"
            parameters["page"] = "\(page)"
            parameters["per_page"] = "\(Config.pixabay.pageSize)"
            if mediaSource == .pixabayImages {
                parameters["image_type"] = "photo"
            } else {
                parameters["video_type"] = "all"
            }
            parameters["q"] = query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
            break
            
        case .flickrImages, .flickrVideos:
            baseURL = Config.flickr.baseUrl
            
            parameters["api_key"] = Config.flickr.apiKey
            parameters["privacy_filter"] = "1"
            parameters["format"] = "json"
            parameters["nojsoncallback"] = "1"
            parameters["method"] = "flickr.photos.search"
            parameters["safe_search"] = "1"
            parameters["page"] = "\(page)"
            parameters["per_page"] = "\(Config.flickr.pageSize)"
            parameters["tags"] = query
            parameters["media"] = mediaSource == .flickrImages ? "photos" : "videos"
            break
        }
        return (baseURL, parameters)
    }
    
    func buildRequestForFlickrImageMetadata(query: String) -> (String, Dictionary<String, String>) {
        let baseURL = Config.flickr.baseUrl
        
        let parameters: Dictionary = [
            "api_key": Config.flickr.apiKey,
            "format": "json",
            "nojsoncallback": "1",
            "method": "flickr.photos.getSizes",
            "photo_id": query
        ]
        return (baseURL, parameters)
    }
}
