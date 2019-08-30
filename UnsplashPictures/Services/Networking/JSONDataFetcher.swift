//
//  JSONDataFetcher.swift
//
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

class JSONDataFetcher: JSONDataFetchable {
    
    private let networkService: NetworkRequestable
    
    // can be initializated with other classes in future (depending of request types)
    init(networkService: NetworkRequestable = NetworkService()) {
        self.networkService = networkService
    }
    
    /// Returns decoded data from Generic Type
    ///
    /// - Parameters:
    ///   - type: T
    ///   - data: Data?
    /// - Returns: T?
    func decodeJSONData<T: Decodable>(of type: T.Type, from data: Data?) -> T? {
        guard let data = data else {
            print(#line, #function, "Error, no data")
            return nil }
        let decoder = JSONDecoder()
        do {
          return try decoder.decode(type, from: data)
        } catch let error {
            print(#line, #function, "Decoding data failed. Error:", error.localizedDescription)
            return nil
        }
        
    }
    
    
    /// Fetching Data of Generic Type
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - response: (T?) -> Void
    func fetchJSONData<T: Decodable>(url: URL, requestType: RequestType, headers: [String:String]?, response: @escaping (T?) -> Void) {
        networkService.request(to: url, type: requestType, headers: headers, with: nil) { data, error in
            guard let decodedData = self.decodeJSONData(of: T.self, from: data) else {
                response(nil)
                return
            }
            
            response(decodedData)
        }
    }

}
