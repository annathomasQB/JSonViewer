//
//  VCModel.swift
//  JsonViewer
//
//  Created by AnnaThomas on 01/04/20.
//  Copyright © 2020 QBurst Technologies. All rights reserved.
//

import Foundation

class ViewControllerModel {
    var jsonModels = [JSONModel]()
    
    /// Function that returns the model for the cell at indexPath
    /// - Parameters:
    ///     - indexPath : the index path related to cell
    /// - Returns: JSon model object at index path
    func data(forRowAt indexPath: IndexPath) -> JSONModel {
        return jsonModels[indexPath.row]
    }
    
    /// Function that returns number of rows
    /// - Returns: Total count of json models
    func numberOfRows() -> Int {
        return jsonModels.count
    }
    
    /// Function that requests for the json Feed from url
    /// - Parameters:
    ///     - completion: Completion handler
    func requestJsonFeedAPI(completion: @escaping (String?) -> Void) {
        guard let jsonURL = URL(string: Constants.jsonFeederURL) else {
            return
        }
        // create url session task to retrieve contents from json URL
        URLSession.shared.dataTask(with: jsonURL) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else {
                return
            }
            do {
                // decode the jsonData from the response
                if let jsonString = String(data: data, encoding: .windowsCP1250) {
                    if let jsonData: Data = jsonString.data(using: .utf8) {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: jsonData, options : .allowFragments) as? Dictionary<String,Any> {
                                let title = json[Constants.jsonKeyTitle] as? String
                                if let jsonRows = json[Constants.jsonKeyRow] as? [Dictionary<String, Any>] {
                                    self.jsonModels = JSONModel.parse(json: jsonRows)!
                                    completion(title)
                                }
                            }
                        }
                    }
                }
            } catch let jsonError {
                print(jsonError)
            }
            // resume() begins the web request
            }.resume()
    }
}
