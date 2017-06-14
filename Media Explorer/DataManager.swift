//
//  DataManager.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/5/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import PromiseKit

protocol SearchResultsDelegate: class {
    func didFinishDataUpdateTask(for content: MediaSource) -> Void
}

final class DataManager {
    
    static let sharedInstance = DataManager()
    var allMedia = [Any]()
    fileprivate let webService = WebService()
    weak var delegate: SearchResultsDelegate! = nil
    
    private func deleteMediaArray() {
        self.allMedia = [Any]()
    }
    
    public func initMediaArray() {
        self.deleteMediaArray()
        for _ in 0..<MediaSource.count {
            allMedia.append(MediaCollection())
        }
    }
    
    public func retrieveAllMedia(forInitialSearchQuery query: String) {
        if allMedia.isEmpty {
            initMediaArray()
        }
        for index in 0..<MediaSource.count {
            firstly {
                webService.fetchPageOfPhotoUrls(forSearchQuery: query, mediaSource: MediaSource(rawValue: index)!, page: 1)
                }.then { mediaCollection -> Void in
                    mediaCollection.query = query
                    self.allMedia[index] = mediaCollection
                }.catch { error in
                    print("error = \(error)")
                }.always {
                    self.delegate.didFinishDataUpdateTask(for: MediaSource(rawValue: index)!)
            }
        }
    }
    
    public func retrieveNextPage(forSource mediaSource: MediaSource) -> Promise<MediaCollection> {
        let collection = allMedia[mediaSource.rawValue] as! MediaCollection
        return webService.fetchPageOfPhotoUrls(forSearchQuery: collection.query!, mediaSource: mediaSource, page: (collection.pageCurrent + 1)).then { newMediaCollection -> Promise<MediaCollection> in
            let mediaArray = newMediaCollection.media
             ((self.allMedia[mediaSource.rawValue] as! MediaCollection).media).append(contentsOf: mediaArray)
            (self.allMedia[mediaSource.rawValue] as! MediaCollection).pageCurrent = newMediaCollection.pageCurrent
            return Promise(value: newMediaCollection)
        }
    }
    
    public func retrieveVideoURLForFlicker(query: String) -> Promise<String> {
        return webService.fetchFlickrImageMetadata(forSearchQuery: query, assetPreference: [.mobileMP4])
    }
    
    public func retrieveImageURLForFlicker(query: String) -> Promise<String> {
        return webService.fetchFlickrImageMetadata(forSearchQuery: query, assetPreference: [.medium800, .medium640, .medium, .small, .largeSquare])
    }
}


