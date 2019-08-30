//
//  NetworkController.swift
//  
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

class NetworkController {
    
    private let jsonDataFetcher: JSONDataFetchable
    
    init(jsonDataFetcher: JSONDataFetchable = JSONDataFetcher()) {
        self.jsonDataFetcher = jsonDataFetcher
    }
    
    private func makeURL(with page: Int) -> URL? {
        var parameters = [String:String]()
        parameters["page"] = String(page)
        parameters["per_page"] = "12"
        parameters["order_by"] = "latest"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/photos"
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        
        return components.url
        
    }
    
    private func makeHeaders() -> [String:String]? {
        var headers = [String:String]()
        headers["Authorization"] = "Client-ID YOUR_API_KEY"
        return headers
    }
    
    func fetchPicturesInfo(page: Int,completion: @escaping ([Picture]?) -> Void) {
        guard let url = makeURL(with: page) else { return }
        jsonDataFetcher.fetchJSONData(url: url, requestType: .get, headers: makeHeaders(), response: completion)
    }
    
}
