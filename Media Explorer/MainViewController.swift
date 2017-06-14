//
//  ViewController.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/4/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import PromiseKit
import Kingfisher
import SVProgressHUD
import DZNEmptyDataSet

final class MainViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SearchResultsDelegate, CollectionViewDelegate, DetailViewDelegate, SpeechRecognizerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var microphoneBarButtonItem: UIBarButtonItem!
    
    let dataManager = DataManager.sharedInstance
    let speechRecognizer = SpeechRecognizer()
    var numberOfSectionsRefreshed = 0
    var currentImageURL = ""
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.refreshControl?.addTarget(self, action: #selector(MainViewController.handleRefresh(refreshControl:)), for: .valueChanged)
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        self.dataManager.delegate = self
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = UIColor.white
            textFieldInsideSearchBar.autocapitalizationType = .none
        }
        self.speechRecognizer.checkForSpeechPermission()
        self.speechRecognizer.delegate = self
    }
    
    @IBAction func voiceSearchButtonAction(_ sender: Any) {
        microphoneBarButtonItem.isEnabled = false
        searchBar.resignFirstResponder()
        
        switch speechRecognizer.status {
        case .ready:
            speechRecognizer.startRecording()
            speechRecognizer.status = .recognizing
        case .recognizing:
            speechRecognizer.cancelRecording()
            speechRecognizer.status = .ready
        default:
            break
        }
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailViewController"{
            if let vc = segue.destination as? DetailViewController {
                vc.delegate = self
                vc.imageURL = currentImageURL
            }
        }
    }
    
    public func dismissDetailView() {
        if let navController = self.navigationController {
            navController.dismiss(animated: true, completion: nil)
        }
    }
}
