//
//  MainViewController+SpeechRecognizer.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/7/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import Speech
import SVProgressHUD
import PromiseKit

extension MainViewController {

    func updateSearchDisplay(searchTerm: String) {
        self.searchBar.text = searchTerm
    }
    
    func updateMicrophoneButtonEnabled(enabled: Bool) {
        self.microphoneBarButtonItem.isEnabled = enabled
    }
    
    func search() {
        SVProgressHUD.show()
        self.dataManager.retrieveAllMedia(forInitialSearchQuery: self.searchBar.text!)
    }
}
