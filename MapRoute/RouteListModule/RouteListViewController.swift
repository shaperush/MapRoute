//
//  RouteViewController.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import UIKit

class RouteListViewController: UIViewController {

    
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: RouteListPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.presenter.configureView()
    }
    
    // Mark - Action
    
    @objc func backClick(param: Any) {
        self.presenter.backTap()
    }
}


extension RouteListViewController: RouteListProtocol {
    
    func updateTableView() {
        self.tableView.reloadData()
    }
    
    func initNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.gray
        let segmentBarItem = UIBarButtonItem(title: "Back".localized(), style: .done, target: self, action: #selector(backClick(param:)))
        navigationItem.leftBarButtonItem = segmentBarItem
    }
}


extension RouteListViewController: UITableViewDataSource,UITableViewDelegate  {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.getRouteList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let routes = self.presenter.getRouteList()
        let rote = routes[indexPath.row]
        cell.textLabel?.text = presenter.getDateFormat(rote.created)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let routes = self.presenter.getRouteList()
        let rote = routes[indexPath.row]
        self.presenter.selectRouteTap(route: rote)
    }
    
}
