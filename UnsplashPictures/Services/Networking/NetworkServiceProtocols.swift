//
//  NetworkServiceProtocols.swift
//  
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

protocol NetworkRequestable {
    func request(to url: URL?, type: RequestType, headers: [String:String]?, with data: Data?, response: @escaping (Data?, Error?) -> Void)
}

protocol JSONDataFetchable {
    func fetchJSONData<T: Decodable>(url: URL, requestType: RequestType, headers: [String:String]?, response: @escaping (T?) -> Void)
}

protocol JSONDataSendable {
    func sendJSONData<T: Codable>(url: URL, with requestType: RequestType, headers: [String:String]?, using model: T, response: @escaping ([String: Any]?, Error?) -> Void)
}



