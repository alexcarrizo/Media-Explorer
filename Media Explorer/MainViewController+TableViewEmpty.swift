//
//  MainViewController+TableViewEmpty.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/11/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit

extension MainViewController {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "Welcome"
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 32, weight: UIFontWeightMedium)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Tap the search bar to search by text\n- or -\nTap the microphone button\nto search by voice"
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: 17, weight: UIFontWeightLight)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.black
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
