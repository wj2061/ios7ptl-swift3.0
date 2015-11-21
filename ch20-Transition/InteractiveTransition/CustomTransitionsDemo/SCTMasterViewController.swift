//
//  SCTMasterViewController.swift
//  CustomTransitionsDemo
//
//  Created by wj on 15/11/21.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class SCTMasterViewController: UITableViewController ,UIViewControllerTransitioningDelegate{
    
    var objects = [NSDate]()
    var destVC :UIViewController?
    
    let scAnimation = SCAnimation()
    let scPercent   = SCTPercentDrivenAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertNewObject")
        navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !view.window!.gestureRecognizers!.contains(scPercent.gestureRecogniser){
            view.window?.addGestureRecognizer(scPercent.gestureRecogniser)
        }
        scPercent.presentingVC = self
    }
    
    override func proceedToNextViewController(){
        if destVC == nil{
             let VC = storyboard!.instantiateViewControllerWithIdentifier("SCTDetailViewController") as! SCTDetailViewController
            VC.detailItem = NSDate()
            VC.transitioningDelegate = self
            VC.scPercent = scPercent
            destVC = VC
        }
        print("pro")
        presentViewController(destVC!, animated: true, completion: nil)
    }
    
    
    func insertNewObject(){
        objects.insert(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    //MARK:- UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scAnimation
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return scAnimation
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("22")
        return scPercent.interactionInProgress ? scPercent : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("33")

        return scPercent.interactionInProgress ? scPercent : nil
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel?.text = object.description
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
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let VC = storyboard!.instantiateViewControllerWithIdentifier("SCTDetailViewController") as! SCTDetailViewController
        VC.detailItem = objects[indexPath.row]
        VC.transitioningDelegate = self
        self.destVC = VC
        VC.scPercent = scPercent
        presentViewController(VC, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
