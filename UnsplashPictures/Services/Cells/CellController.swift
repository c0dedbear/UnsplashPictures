//
//  CellController.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 30/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import Foundation
import SDWebImage

class CellController {
    
    func setupCell(in collectionView: UICollectionView, for indexPath: IndexPath, for cell: PictureCell, using picture: Picture) {
        
        let pictureImageUrl = picture.urls["small"]
        guard let url = pictureImageUrl, let imageUrl = URL(string: url) else { return }
        
        // fetch and automatically setup image for cell using SDWebImage
        cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imageView.sd_imageIndicator = SDWebImageProgressIndicator.`default`
        cell.imageView.sd_setImage(with: imageUrl, placeholderImage: nil, options: [.continueInBackground, .refreshCached])
    }
}
