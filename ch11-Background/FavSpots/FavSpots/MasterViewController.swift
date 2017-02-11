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
    
    lazy var fetchedResultsController:NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in 
        let app = UIApplication.shared.delegate as? AppDelegate
        let  context = app!.managedObjectContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Spot")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        request.fetchBatchSize = 20
        let  Controller  =  NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return Controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self;
        do {
            try  fetchedResultsController.performFetch()
        }catch{
            print("Unresolved error")
        }
      
        


    }
    
    func configureCell(_ cell:UITableViewCell,indexpath:IndexPath){
        if let spot = fetchedResultsController.object(at: indexpath) as? Spot{
            cell.textLabel?.text = spot.name
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        configureCell(cell, indexpath: indexPath)

        // Configure the cell...

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath) as! NSManagedObject)
            
            
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
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let spot = fetchedResultsController.object(at: indexPath) as! Spot
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
        case .update:
            let cell = tableView.cellForRow(at: indexPath!)
            configureCell(cell!, indexpath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //MARK: - UIDataSourceModelAssociation
  

    
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        print("\(#function)" )
        if let spot = fetchedResultsController.object(at: idx) as? Spot{
            return spot.objectID.uriRepresentation().absoluteString
        }
        return nil
    }
    
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        print("\(#function)" )
        let numbersOfRows = tableView.numberOfRows(inSection: 0)
        
        for row in 0..<numbersOfRows{
            let indexpath = IndexPath(row: row, section: 0)
           let spot = fetchedResultsController.object(at: indexpath) as! Spot
            if spot.objectID.uriRepresentation().absoluteString == identifier{
                return indexpath
            }
        }
        return nil
    }



}
