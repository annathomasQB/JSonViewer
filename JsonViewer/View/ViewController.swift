//
//  ViewController.swift
//  JsonViewer
//
//  Created by AnnaThomas on 31/03/20.
//  Copyright © 2020 QBurst Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var jSonFeederTableView = UITableView()
    var viewModel = ViewControllerModel()
    private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialize basic table view setup
        jSonFeederTableView = UITableView()
        jSonFeederTableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(jSonFeederTableView)

        refreshControl = UIRefreshControl()
        jSonFeederTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44 + statusBarHeight))
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)

        // top anchor
        jSonFeederTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        // leading anchor
        jSonFeederTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        // trailing anchor
        jSonFeederTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        // bottom anchor
        jSonFeederTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        jSonFeederTableView.dataSource = self
        jSonFeederTableView.allowsSelection = false
        jSonFeederTableView.rowHeight = UITableView.automaticDimension
        jSonFeederTableView.estimatedRowHeight = 50
        jSonFeederTableView.register(JSONTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        
        
        // make tableview frame just below the statu bar
        let BarHeight : CGFloat = UIApplication.shared.statusBarFrame.size.height
        let frame = self.jSonFeederTableView.frame
        jSonFeederTableView.frame = CGRect(x: 0, y: BarHeight, width: frame.width, height: frame.height - BarHeight)
        
        refreshTable()

    }
    
    @objc private func refreshTable() {
        viewModel.requestJsonFeedAPI { (title) in
            DispatchQueue.main.async {
                self.jSonFeederTableView.reloadData()
                self.refreshControl.endRefreshing()
                if let title = title {
                    self.navigationItem.title = title
                }
            }
        }
    }


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as! JSONTableViewCell
        cell.jsonModel = viewModel.data(forRowAt: indexPath)
        return cell
    }
    
    
}
