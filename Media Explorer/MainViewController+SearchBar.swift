//
//  MainViewController+SearchBar.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/7/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import PromiseKit
import SVProgressHUD

extension MainViewController {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchString: String = searchBar.text, searchString.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            after(interval: 0.5).always {
                SVProgressHUD.show()
                self.dataManager.retrieveAllMedia(forInitialSearchQuery: searchString)
            }
        } else {
            searchBar.text = ""
            dataManager.initMediaArray()
            self.tableView.reloadData()
        }
    }
}
