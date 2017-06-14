//
//  MainViewController+TableViewDataSource.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/11/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit

extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !dataManager.allMedia.isEmpty {
            return MediaSource.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        if let collection: MediaCollection = dataManager.allMedia[section] as? MediaCollection {
            let totalNumber: Int = collection.totalNumberOfResults
            if totalNumber > 0 {
                numberOfRows = 1
            }
        }
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.source = MediaSource.init(section: indexPath.section)
        cell.delegate = self
        cell.collectionView.reloadData()
        return cell
    }
}
