//
//  SecondViewController.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 29/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit
import SDWebImage

class DetailPictureViewController: UIViewController {
    
    // MARK: Dependencies
    let storageController = StorageController()
    
    // MARK: Properties
    var rawImageURL: URL!
    var dates = [URL:Date]() {
        didSet {
            storageController.save(dates: dates)
            print(dates.count)
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var detailImageView: UIImageView!
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForLoading()
        setRawImage()
    }
    
    // MARK: Methods
    func prepareForLoading() {
        navigationItem.title = "Loading..."
        if let existingDates = storageController.loadDates() {
            dates = existingDates
        }
    }
    
    func setRawImage() {
        detailImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        detailImageView.sd_imageIndicator = SDWebImageProgressIndicator.`default`
        detailImageView.sd_setImage(with: self.rawImageURL,
                                    placeholderImage: nil,
                                    options: .continueInBackground,
                                    completed: { (image, _, _, url) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy 'at' HH:mm:ss"
            
            if url != nil && image != nil {
                if let existingDate = self.dates[url!] {
                    self.navigationItem.title = "Loaded \(dateFormatter.string(from: existingDate))"
                } else {
                    self.dates[url!] = Date()
                    self.navigationItem.title = "Loaded \(dateFormatter.string(from: Date()))"
                }
            }
        })
    }
    
    
}

