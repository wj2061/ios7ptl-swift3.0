//
//  MasterViewController.swift
//  FavSpots
//
//  Created by wj on 15/10/27.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit
import CoreData


class MasterViewController: UITableViewController,NSFetchedResultsControllerDelegate,UIDataSourceModelAssociation {
    
    lazy var fetchedResultsController:NSFetchedResultsController = {
        let app = UIApplication.sharedApplication().delegate as? AppDelegate
        let  context = app!.managedObjectContext
        
        let request = NSFetchRequest(entityName: "Spot")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        request.fetchBatchSize = 20
        let  Controller  =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        Controller.delegate = self
        do {
            try  Controller.performFetch()
        }catch{
            print("Unresolved error")
        }
        return Controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        


    }
    
    func configureCell(cell:UITableViewCell,indexpath:NSIndexPath){
        if let spot = fetchedResultsController.objectAtIndexPath(indexpath) as? Spot{
            cell.textLabel?.text = spot.name
        }
    }



    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        configureCell(cell, indexpath: indexPath)

        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = fetchedResultsController.managedObjectContext
            context.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            
            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destinationViewController as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let spot = fetchedResultsController.objectAtIndexPath(indexPath) as! Spot
            vc.spot = spot
        }
    }
    
    //MARK: - NSFetchedResultsControllerDelegate
//    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
//        switch type{
//        case .Insert:
//            
//            
//        }
//    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type{
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            let cell = tableView.cellForRowAtIndexPath(indexPath!)
            configureCell(cell!, indexpath: indexPath!)
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    //MARK: - UIDataSourceModelAssociation
  

    
    func modelIdentifierForElementAtIndexPath(idx: NSIndexPath, inView view: UIView) -> String? {
        print("\(__FUNCTION__)" )
        if let spot = fetchedResultsController.objectAtIndexPath(idx) as? Spot{
            return spot.objectID.URIRepresentation().absoluteString
        }
        return nil
    }
    
    func indexPathForElementWithModelIdentifier(identifier: String, inView view: UIView) -> NSIndexPath? {
        print("\(__FUNCTION__)" )
        let numbersOfRows = tableView.numberOfRowsInSection(0)
        
        for row in 0..<numbersOfRows{
            let indexpath = NSIndexPath(forRow: row, inSection: 0)
           let spot = fetchedResultsController.objectAtIndexPath(indexpath) as! Spot
            if spot.objectID.URIRepresentation().absoluteURL == identifier{
                return indexpath
            }
        }
        return nil
    }



}
