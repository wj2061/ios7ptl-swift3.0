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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueForKeyPath("array.numbers")!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let descriptions = array.valueForKeyPath("numbers.description") as! [String]
        cell.textLabel?.text = descriptions[indexPath.row]
        return cell
    }

}
