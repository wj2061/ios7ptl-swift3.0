//
//  DirectoryViewController.swift
//  FileExplorer
//
//  Created by wj on 15/11/8.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class DirectoryViewController: UITableViewController {
    
    var  path:String?{
        didSet{
            if let st = path{
                title = (st as NSString).lastPathComponent
            }
        }
    }
    
    var contents = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContents()
        tableView.reloadData()
    }
    
    func loadContents(){
        if path == nil{
            path  = "/"
        }
        let fileManager = NSFileManager()
        
        do {
            contents = try  fileManager.contentsOfDirectoryAtPath(path!)
        }catch let error {
            print("error : \(error )")
        }
        print("contents: \(contents.count)")
    }
    
    func isDirectoryAtEntryPath(entryPath:String)->Bool  {
        let isDirectory = UnsafeMutablePointer<ObjCBool>.alloc(1)
        isDirectory[0] = false
        let fm = NSFileManager()
        let fullPath = (path! as NSString).stringByAppendingPathComponent(entryPath)
        fm.fileExistsAtPath(fullPath, isDirectory: isDirectory)
        return Bool(isDirectory[0])
    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let entryPath = contents[indexPath.row]
        let fm = NSFileManager()
        var attributes=[String:AnyObject]()
        
        do{
            attributes = try  fm.attributesOfItemAtPath(entryPath)
        }catch let error {
            print("error = \(error)")
        }
        print("attributes = \(attributes)")
        
        let Permissions = attributes[NSFilePosixPermissions] == nil ? "" : "\(attributes[NSFilePosixPermissions]!)"
        let name = attributes[NSFileOwnerAccountName] == nil ? "" : "\(attributes[NSFileOwnerAccountName]!)"
        let id = attributes[NSFileOwnerAccountID] == nil ? "" : "\(attributes[NSFileOwnerAccountID]!)"
        cell.textLabel?.text = "\(Permissions)  \(name)(\(id))  \((entryPath as NSString).lastPathComponent)"
        
        if isDirectoryAtEntryPath(entryPath){
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let entrypath = contents[indexPath.row]
        return isDirectoryAtEntryPath(entrypath) ? indexPath : nil
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let VC = segue.destinationViewController as! DirectoryViewController
        
        let entrypath = contents[tableView.indexPathForSelectedRow!.row]
        let fullpath = (path! as NSString).stringByAppendingPathComponent(entrypath)
        
        VC.path = fullpath
    }
}
