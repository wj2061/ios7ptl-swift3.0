//
//  SCTMasterViewController.swift
//  CustomTransitionsDemo
//
//  Created by wj on 15/11/21.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class SCTMasterViewController: UITableViewController ,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning{
    
    var objects = [Date]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(SCTMasterViewController.insertNewObject))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func insertNewObject(){
        objects.insert(Date(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    //MARK:- UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //MARK : -UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let src = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let dest = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        var f = src.view.frame
        let originalSourceRect = f
        
        f.origin.y = f.size.height
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            src.view.frame = f
            }, completion: { (_) -> Void in
                src.view.alpha = 0
                dest.view.alpha = 0
                dest.view.frame = f
                transitionContext.containerView.addSubview(dest.view)
                
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    dest.view.alpha = 1
                    dest.view.frame = originalSourceRect
                    }, completion: { (_ ) -> Void in
                        src.view.alpha = 1
                        transitionContext.completeTransition(true)
                })
        }) 
    }
  


    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel?.text = object.description
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
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = storyboard!.instantiateViewController(withIdentifier: "SCTDetailViewController") as! SCTDetailViewController
        VC.detailItem = objects[indexPath.row]
        VC.transitioningDelegate = self
        present(VC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
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
