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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize basic table view setup
        jSonFeedertableView = UITableView(frame: self.view.bounds, style: .plain)
        jSonFeedertableView.dataSource = self
        jSonFeedertableView.delegate = self
        jSonFeedertableView.backgroundColor = .white
        jSonFeedertableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier)
        cell?.textLabel?.text = "This is row \(indexPath.row)"
        
        return cell!
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
