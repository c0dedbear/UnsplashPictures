//
//  PictureCell.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 29/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit

class PictureCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var metaLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
}
