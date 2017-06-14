//
//  DetailViewController.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/8/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import UIKit
import Kingfisher
import PromiseKit
import SVProgressHUD

protocol DetailViewDelegate: class {
    func dismissDetailView() -> Void
}

final class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundCloseButtonView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: DetailViewDelegate?
    let dataManager = DataManager.sharedInstance
    var imageURL = ""
    var photoId = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundCloseButtonView.layer.cornerRadius = self.backgroundCloseButtonView.bounds.size.width/2
        self.backgroundCloseButtonView.layer.masksToBounds = true
        self.backgroundCloseButtonView.isHidden = true
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.loadImage()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.delegate?.dismissDetailView()
    }
    
    fileprivate func loadImage() {
        SVProgressHUD.show()
        if self.imageURL != "" {
            self.imageView.kf.setImage(with: URL(string: self.imageURL)!, options: [.transition(.fade(0.7))],  completionHandler: {
                (image, error, cacheType, imageUrl) in
                if error == nil {
                    SVProgressHUD.dismiss()
                    self.backgroundCloseButtonView.isHidden = false
                }
            })
        } else {
            SVProgressHUD.dismiss()
        }
    }
}
