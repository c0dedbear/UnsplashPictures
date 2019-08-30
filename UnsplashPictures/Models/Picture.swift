//
//  Picture.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 29/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import Foundation

struct Picture: Codable {
    let width, height: Int
    let urls: [Urls.RawValue:String]
    
    enum Urls: String {
        case raw, full, regular, small, thumb
    }

}

