//
//  JSONModel.swift
//  JsonViewer
//
//  Created by AnnaThomas on 01/04/20.
//  Copyright © 2020 QBurst Technologies. All rights reserved.
//

import Foundation

struct JSONModel: Codable {
    
    var id: Int?
    var title: String?
    var description: String?
    var image: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "title"
        case description = "description"
        case image = "imageHref"
    }
}

extension JSONModel {
    static func parse(json: [Dictionary<String,Any>]) -> [JSONModel]? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []) {
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([JSONModel].self, from: jsonData)
                return response
            }
            catch {
                debugPrint(error)
            }
        }
        return nil
    }
}

