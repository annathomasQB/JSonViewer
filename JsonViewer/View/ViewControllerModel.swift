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
    
    
    func data(forRowAt indexPath: IndexPath) -> JSONModel {
        return jsonModels[indexPath.row]
    }
    
    func numberOfRows() -> Int {
        return jsonModels.count
    }
    
    /// Function that requests for the json Feed from url
    func requestJsonFeedAPI(completion: @escaping () -> Void) {
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
                                
                                if let jsonRows = json[Constants.jsonKeyRow] as? [Dictionary<String, Any>] {
                                    self.jsonModels = JSONModel.parse(json: jsonRows)!
                                    completion()
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
