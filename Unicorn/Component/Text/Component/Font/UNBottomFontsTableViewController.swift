//
//  UNBottomFontsTableViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/4.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBottomFontsTableViewController: UITableViewController {
    var fonts = [String]() {didSet{ tableView.reloadData() }}
    var cellSelected: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "这是字体"
        cell.textLabel?.font = UIFont(name: fonts[indexPath.row], size: 20)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
    
}
