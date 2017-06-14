//
//  UIScrollView+resetScroll.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/6/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    /// Sets content offset to the top and left
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
}
