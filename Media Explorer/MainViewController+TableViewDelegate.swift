//
//  MainViewController+TableViewDelegate.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/11/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit

extension MainViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        if let collection: MediaCollection = dataManager.allMedia[section] as? MediaCollection {
            let totalNumber: Int = collection.totalNumberOfResults
            let (source, type) = (MediaSource.init(section: section)?.sectionTitle)!
            if totalNumber > 0 {
                title = "\(source) > \(totalNumber) \(type)\((totalNumber == 1) ? "" : "s")"
            }
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)
        header.tintColor = UIColor.black
    }
}
