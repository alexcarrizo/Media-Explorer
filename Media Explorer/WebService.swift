//
//  WebService.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/8/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import Alamofire
import PromiseKit
import SwiftyJSON

final class WebService {
    
    func fetchPageOfPhotoUrls(forSearchQuery query: String, mediaSource: MediaSource, page: Int) -> Promise<MediaCollection> {
        let (baseURL, parameters) = buildRequestForListOfPhotoUrls(query: query, mediaSource: mediaSource, page: page)
        return self.fetchJSON(baseURL: baseURL, parameters: parameters).then { json -> MediaCollection in
            return(self.parseResultsBySource(json: json, mediaSource: mediaSource))
        }
    }
    
    func fetchFlickrImageMetadata(forSearchQuery query: String, assetPreference: [FlickrMediaSize]) -> Promise<String> {
        let (baseURL, parameters) = buildRequestForFlickrImageMetadata(query: query)
        return self.fetchJSON(baseURL: baseURL, parameters: parameters).then { json -> String in
            return(self.parseResultsForFlickrImageMetadata(json: json, preferredAsset: assetPreference))
        }
    }
    
    // MARK: Alamofire request
        
    func fetchJSON(baseURL: String, parameters: Dictionary<String, Any>) -> Promise<JSON> {
        return Promise { fulfill, reject in
            Alamofire.request(baseURL, parameters: parameters)
                .responseJSON { response in
                    if let result = response.result.value {
                        fulfill(JSON(result))
                    } else {
                        reject(response.error!)
                    }
            }
        }
    }
}
