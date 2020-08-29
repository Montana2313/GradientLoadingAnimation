//
//  DataManager.swift
//  BackgroundLoading
//
//  Created by Mac on 29.08.2020.
//  Copyright © 2020 Mac. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class DataManager {
    private var requestURL = "https://gorest.co.in/public-api/posts"
    var publishedObject = BehaviorSubject<Example?>(value: nil)
    func getPhotos(){
        guard let url = URL(string: self.requestURL) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                let httpResponse = response as! HTTPURLResponse
                print("Request Response \(httpResponse.statusCode)")
            }
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            if let data = data {
                self.parseJSON(data)
            }
            
        }
        
        task.resume()
    }
    
    private func parseJSON(_ data : Data) {
        do {
            let converter = JSONDecoder()
            let convertedData = try converter.decode(Example.self, from: data)
            print(convertedData.data)
            self.publishedObject.onNext(convertedData)
        }catch {
            print(error.localizedDescription)
        }
    }
}
// MARK: - Example
struct Example: Codable {
    let code: Int
    let meta: Meta
    let data: [Datum]
}

// MARK: - Data
struct Datum: Codable {
    let id, userID: Int
    let title, body, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case title, body
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let total, pages, page, limit: Int
}
