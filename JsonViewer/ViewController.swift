//
//  ViewController.swift
//  JsonViewer
//
//  Created by AnnaThomas on 31/03/20.
//  Copyright © 2020 QBurst Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var jSonFeedertableView = UITableView()
    var viewModel = ViewControllerModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize basic table view setup
        jSonFeedertableView = UITableView(frame: self.view.bounds, style: .plain)
        jSonFeedertableView.dataSource = self
        jSonFeedertableView.delegate = self
        jSonFeedertableView.backgroundColor = .white
        jSonFeedertableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        
        
        // make tableview frame just below the statu bar
        let BarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        let frame = self.jSonFeedertableView.frame
        jSonFeedertableView.frame = CGRect(x: 0, y: BarHeight, width: frame.width, height: frame.height - BarHeight)
        
        view.addSubview(jSonFeedertableView)
        
        requestJsonFeedAPI()
    }
    
    /// Function that requests for the json Feed from url
    func requestJsonFeedAPI() {
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
                            
                            if let jsonRows = json["rows"] as? [Dictionary<String, Any>] {
                                self.viewModel.jsonModels = JSONModel.parse(json: jsonRows)!
                                DispatchQueue.main.async {
                                    self.jSonFeedertableView.reloadData()
                                }
                            }
                        }
                    }
                    }
                }
                
//                let jsonData = try JSONDecoder().decode(JSONModel.self, from: data)
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: [])
                print(jsonResponse) //Response result
            } catch let jsonError {
                print(jsonError)
            }
        // resume() begins the web request
        }.resume()
    }


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.jsonModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier)
        let jsonForCell = viewModel.jsonModels[indexPath.row]
        cell?.textLabel?.text = jsonForCell.title
        cell?.detailTextLabel?.text = jsonForCell.description
        return cell!
    }
    
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
}
