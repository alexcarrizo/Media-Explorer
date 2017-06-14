//
//  MainViewController+DataRefresh.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/7/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import SVProgressHUD

extension MainViewController {
    
    public func handleRefresh(refreshControl: UIRefreshControl) {
        self.refreshCollectionViews()
        refreshControl.endRefreshing()
    }
    
    fileprivate func refreshCollectionViews() {
        for index in 0..<MediaSource.count {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: index)) {
                if let collectionView = (cell as! CollectionViewCell).collectionView {
                    collectionView.reloadData()
                    collectionView.resetScrollPositionToTop()
                }
            }
        }
    }
    
    public func didFinishDataUpdateTask(for content: MediaSource) {
        self.numberOfSectionsRefreshed += 1
        
        if let collectionView = (self.tableView.cellForRow(at: IndexPath(row: 0, section: content.rawValue)) as? CollectionViewCell)?.collectionView {
            collectionView.reloadData()
            collectionView.resetScrollPositionToTop()
            //collectionView.setNeedsLayout()
        }
        if self.numberOfSectionsRefreshed == MediaSource.count {
            self.numberOfSectionsRefreshed = 0
            SVProgressHUD.dismiss()
        }
        self.tableView.reloadData()
    }
}
