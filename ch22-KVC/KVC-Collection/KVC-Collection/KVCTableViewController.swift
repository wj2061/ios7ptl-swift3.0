//
//  KVCTableViewController.swift
//  KVC-Collection
//
//  Created by wj on 15/11/29.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class KVCTableViewController: UITableViewController {
    var array : TimesTwoArray!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (value(forKeyPath: "array.numbers")! as AnyObject).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let descriptions = array.value(forKeyPath: "numbers.description") as! [String]
        cell.textLabel?.text = descriptions[indexPath.row]
        return cell
    }

}
