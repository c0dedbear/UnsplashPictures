//
//  StorageController.swift
//  UnsplashPictures
//
//  Created by Михаил Медведев on 30/08/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import Foundation

class StorageController {

   private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
   private let picturesInfoArchiveURL: URL
   private let datesURL: URL
    
    init() {
        picturesInfoArchiveURL = documentDirectory.appendingPathComponent("Pictures").appendingPathExtension("plist")
        datesURL  = documentDirectory.appendingPathComponent("dates").appendingPathExtension("plist")
    }

    // MARK: Pictures
    func save(pictures: [Picture]) {
        let encoder = PropertyListEncoder()
        guard let encodedPictures = try? encoder.encode(pictures) else { return }
        try? encodedPictures.write(to: picturesInfoArchiveURL, options: .noFileProtection)
        
    }
    
    func load() -> [Picture]? {
        guard let data = try? Data(contentsOf: picturesInfoArchiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([Picture].self, from: data)
    }
    
    // MARK: - Dates
    func save(dates: [URL:Date]) {
        let encoder = PropertyListEncoder()
        guard let dates = try? encoder.encode(dates) else { return }
        try? dates.write(to: datesURL, options: .noFileProtection)
    }
    
    func loadDates() -> [URL:Date]? {
        guard let data = try? Data(contentsOf: datesURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode([URL:Date].self, from: data)
    }
    
    
}
