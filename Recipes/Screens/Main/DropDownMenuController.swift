//
//  DropDownMenuController.swift
//  Recipes
//
//  Created by Damian Markowski on 25.02.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit

class DropDownMenuController: UIViewController {

    // Constants
    private let menuItemCellIdentifier = "MenuItem"
    // Views
    private var list: UITableView!
    
    // Public properties
    var data = [String]()
    var cellTapped: ((_ row: Int)->())?

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addList()
    }
    
    private func addList(){
        list = UITableView()
        configureList()
        view.addSubview(list)
        list.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsToList()
    }
    
    private func configureList(){
        list.dataSource = self
        list.delegate = self
        list.tableFooterView = UIView()
        list.register(UITableViewCell.self, forCellReuseIdentifier: menuItemCellIdentifier)
    }
    
    private func addConstraintsToList(){
        let leading = NSLayoutConstraint(item: list, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0)
        let top = NSLayoutConstraint(item: list, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: list, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: list, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraints([leading, top, trailing, bottom])
    }
}

extension DropDownMenuController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuItemCellIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellTapped = cellTapped {
            cellTapped(indexPath.row)
        }
    }
}
