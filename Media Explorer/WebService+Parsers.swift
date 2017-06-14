//
//  WebService+Pixabay.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/8/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import PromiseKit
import SwiftyJSON

//MARK:  JSON parsers and web service calls go here

extension WebService {
    
    func parseResultsBySource(json: JSON, mediaSource: MediaSource) -> MediaCollection {
        let mediaCollection = MediaCollection()
        
        switch mediaSource {
        case .pixabayImages, .pixabayVideos:
            
            if let totalHits = json["totalHits"].int, let assets = json["hits"].array {
                for index in 0..<assets.count {
                    mediaCollection.media.append(self.parseResultsForPixabayMediaMetadata(asset: assets[index], byMediaSource: mediaSource))
                }
                mediaCollection.mediaSource = mediaSource
                mediaCollection.pageCurrent = 1
                mediaCollection.pageSize = 20
                mediaCollection.pages = Int(floor(Double(totalHits/mediaCollection.pageSize)))
                mediaCollection.totalNumberOfResults = totalHits
            }
            break
        case .flickrImages, .flickrVideos:
            
            if let totalHits = Int(json["photos"]["total"].string!), let assets = json["photos"]["photo"].array {
                for index in 0..<assets.count {
                    mediaCollection.media.append(self.parseResultsForFlickrMediaMetadata(asset: assets[index], byMediaSource: mediaSource))
                }
                mediaCollection.mediaSource = mediaSource
                if let page = json["photos"]["page"].int {
                    mediaCollection.pageCurrent = page
}
                if let pages = json["photos"]["pages"].int { mediaCollection.pages = pages }
                if let pageSize = json["photos"]["perpage"].int { mediaCollection.pageSize = pageSize }
                mediaCollection.totalNumberOfResults = totalHits
            }
            break
        }
        return mediaCollection
    }
    
    func parseResultsForPixabayMediaMetadata(asset: JSON, byMediaSource mediaSource: MediaSource) -> Media {
        if mediaSource == .pixabayImages {
            let media = Image()
            media.thumbnailURL = asset["previewURL"].string
            media.thumbnailHeight = asset["previewHeight"].int
            media.thumbnailWidth = asset["previewWidth"].int
            media.imageURL = asset["webformatURL"].string
            media.imageHeight = asset["webformatHeight"].int
            media.imageWidth = asset["webformatWidth"].int
            
            return media
        }
        
        let media = Video()
        media.thumbnailURL = "https://i.vimeocdn.com/video/\(asset["picture_id"].stringValue)_200x150.jpg"
        media.thumbnailHeight = 100
        media.thumbnailWidth = 150
        media.videoURL = asset["videos"]["medium"]["url"].string
        media.videoHeight = asset["videos"]["medium"]["height"].int
        media.videoWidth = asset["videos"]["medium"]["width"].int
        media.videoSize = asset["videos"]["medium"]["size"].int
        
        return media
    }
    
    func parseResultsForFlickrMediaMetadata(asset: JSON, byMediaSource mediaSource: MediaSource) -> Media {
        var media = Media()
        if mediaSource == .flickrImages {
            media = Image()
        } else if mediaSource == .flickrVideos {
            media = Video()
        }
        
        let photoID = asset["id"].stringValue
        let farm = asset["farm"].stringValue
        let server = asset["server"].stringValue
        let secret = asset["secret"].stringValue
        
        media.imageId = photoID
        media.thumbnailURL = "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_m.jpg"
        media.thumbnailHeight = 100
        media.thumbnailWidth = 150
        
        return media
    }
    
    func parseResultsForFlickrImageMetadata(json:JSON, preferredAsset: [FlickrMediaSize]) -> String {
        var photoURL = ""
        if let inventory = json["sizes"]["size"].array {
            for search in preferredAsset {
                for asset in inventory {
                    if asset["label"].string == search.string {
                        if let sourceURL = asset["source"].string {
                            photoURL = sourceURL
                            break
                        }
                    }
                }
                if photoURL != "" {
                    break
                }
            }
        }
        return photoURL
    }
}
