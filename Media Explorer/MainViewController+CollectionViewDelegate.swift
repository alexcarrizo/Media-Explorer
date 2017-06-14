//
//  MainViewController+DetailViewDelegate.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/12/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//


import UIKit
import AVKit
import PromiseKit
import AVFoundation
import SVProgressHUD

extension MainViewController {
    
    public func showDetailView(source: MediaSource, selectedRow: Int) {
        let media = (self.dataManager.allMedia[source.rawValue] as! MediaCollection).media
        
        if selectedRow < media.count {
            let asset = media[selectedRow]
            
            // test if video
            if let videoAsset: Video = asset as? Video {
                if let videoURL = videoAsset.videoURL, videoURL != "" {
                    self.playVideo(videoURL: videoURL)
                } else {
                    if let photoId = videoAsset.imageId, photoId != "" {
                        SVProgressHUD.show()
                        firstly {
                            self.dataManager.retrieveVideoURLForFlicker(query: photoId)
                            }.then { videoURL -> Void in
                                self.playVideo(videoURL: videoURL)
                            }.catch { error in
                                print("error = \(error)")
                            }.always {
                                SVProgressHUD.dismiss()
                        }
                    }
                }
            } else {
                
                // image
                if let imageAsset: Image = asset as? Image {
                    if let imageURL = imageAsset.imageURL, imageURL != "" {
                        self.currentImageURL = imageURL
                        self.performSegue(withIdentifier: "showDetailViewController", sender: self)
                    } else {
                        if let photoId = imageAsset.imageId, photoId != "" {
                            SVProgressHUD.show()
                            firstly {
                                self.dataManager.retrieveImageURLForFlicker(query: photoId)
                                }.then { imageURL -> Void in
                                    self.currentImageURL = imageURL
                                    self.performSegue(withIdentifier: "showDetailViewController", sender: self)
                                }.catch { error in
                                    print("error = \(error)")
                                }.always {
                                    SVProgressHUD.dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
    
    internal func playVideo(videoURL: String) {
        let player = AVPlayer(url: URL(string: videoURL)!)
        player.allowsExternalPlayback = true
        
        let playerViewController = AVPlayerViewController()
        playerViewController.allowsPictureInPicturePlayback = true
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func getNextPage(source: MediaSource) -> Promise<MediaCollection> {
        return self.dataManager.retrieveNextPage(forSource: source)
    }
}
