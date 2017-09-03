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
        let fileManager = FileManager()
        
        do {
            contents = try  fileManager.contentsOfDirectory(atPath: path!)
        }catch let error {
            print("error : \(error )")
        }
        print("contents: \(contents.count)")
    }
    
    func isDirectoryAtEntryPath(_ entryPath:String)->Bool  {
        var isDirectory:ObjCBool = false;
        let fm = FileManager()
        let fullPath = (path! as NSString).appendingPathComponent(entryPath)
        fm.fileExists(atPath: fullPath, isDirectory: &isDirectory)
        return isDirectory.boolValue;
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let entryPath = contents[indexPath.row]
        let fm = FileManager()
        var attributes=[FileAttributeKey:Any]()
        
        do{
            attributes = try  fm.attributesOfItem(atPath: entryPath)
        }catch let error {
            print("error = \(error)")
        }
        print("attributes = \(attributes)")
        
        let permissions = attributes[FileAttributeKey.posixPermissions] == nil ? "" : "\(attributes[FileAttributeKey.posixPermissions]!)"
        let name = attributes[FileAttributeKey.ownerAccountName] == nil ? "" : "\(attributes[FileAttributeKey.ownerAccountName]!)"
        let id = attributes[FileAttributeKey.ownerAccountID] == nil ? "" : "\(attributes[FileAttributeKey.ownerAccountID]!)"
        cell.textLabel?.text = "\(permissions)  \(name)(\(id))  \((entryPath as NSString).lastPathComponent)"
        
        if isDirectoryAtEntryPath(entryPath){
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.blue
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let entrypath = contents[indexPath.row]
        return isDirectoryAtEntryPath(entrypath) ? indexPath : nil
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DirectoryViewController
        
        let entrypath = contents[tableView.indexPathForSelectedRow!.row]
        let fullpath = (path! as NSString).appendingPathComponent(entrypath)
        
        vc.path = fullpath
    }
}
