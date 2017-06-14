//
//  CollectionViewCell.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/4/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher
import PromiseKit

protocol CollectionViewDelegate: class {
    func showDetailView(source: MediaSource, selectedRow: Int)
    func getNextPage(source: MediaSource) -> Promise<MediaCollection>
}

final class CollectionViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewDelegate?
    let dataManager = DataManager.sharedInstance
    var source: MediaSource?
    var currentMedia: Media?
}

extension CollectionViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var totalCount = 0
        if let collection: MediaCollection = dataManager.allMedia[source!.rawValue] as? MediaCollection {
            totalCount = collection.totalNumberOfResults
        }
        return totalCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCell
        
        if let source = source {
            var mediaCollection = dataManager.allMedia[source.rawValue] as! MediaCollection
            if indexPath.row > mediaCollection.media.count &&
                indexPath.row < mediaCollection.totalNumberOfResults &&
                mediaCollection.media.count < mediaCollection.totalNumberOfResults {
                // get next page
                firstly {
                    //self.dataManager.retrieveNextPage(forSource: category)
                    
                    (self.delegate?.getNextPage(source: source))!
                    
                    }.catch { error in
                        print("error = \(error)")
                    }.always {
                        mediaCollection = self.dataManager.allMedia[source.rawValue] as! MediaCollection
                        self.currentMedia = mediaCollection.media[indexPath.row] as? Media
                        if let thumbnailURL = self.currentMedia?.thumbnailURL {
                            cell.imageView.kf.indicatorType = .activity
                            cell.imageView.kf.setImage(with: URL(string: thumbnailURL)!)
                        }
                }
            } else {
                if indexPath.row < mediaCollection.media.count {
                    
                    currentMedia = mediaCollection.media[indexPath.row] as? Media
                    if let thumbnailURL = currentMedia?.thumbnailURL {
                        cell.imageView.kf.indicatorType = .activity
                        cell.imageView.kf.setImage(with: URL(string: thumbnailURL)!)
                    }
                }
            }
        }
        return cell
    }
}

extension CollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let source = source {
            delegate?.showDetailView(source: source, selectedRow: indexPath.row)
        }
    }
}

extension MediaSource {
    
    static let sectionTitleMapper: [MediaSource: (String, String)] = [
        .pixabayImages: ("Pixabay", "Image"),
        .pixabayVideos: ("Pixabay", "Video"),
        .flickrImages:  ("Flickr", "Image"),
        .flickrVideos:  ("Flickr", "Video")
    ]
    var sectionTitle: (String, String) {
        return MediaSource.sectionTitleMapper[self]!
    }
}
