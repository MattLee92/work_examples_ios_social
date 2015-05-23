//
//  ContactTableViewController.swift
//  Social
//
//  Created by Matthew Lee on 19/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController, DetailViewControllerDelegate {

    var contacts = Array<Contact>()
    var currentContact: Contact!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func AddContact(sender: AnyObject) {
        currentContact = Contact()
        contacts.append(currentContact)
       performSegueWithIdentifier("ShowDetail", sender: self)
       
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

                let contact = contacts[indexPath.row]
      
        
        let conToImage: (NSData?) -> Void = {
            if let d = $0 {
                let image = UIImage(data: d)
                
                var frame = cell.imageView!.frame
                let imageSize = 32 as CGFloat
                frame.size.height = imageSize
                frame.size.width = imageSize
                cell.imageView?.frame = frame
                cell.imageView?.layer.cornerRadius = imageSize / 2.0
                cell.imageView?.clipsToBounds = true
              
                cell.imageView?.image = image
                
            } else {
               
            }
        }
        if let d = contacts[indexPath.row].image {
            conToImage(d)
        } else {
            contact.loadimage(conToImage)
        }

          cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        
        return cell
    }
    
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    
    func detailViewController(dvc: DetailTableViewController, contact: Contact){
        navigationController?.popToViewController(self, animated: true)
        tableView.reloadData()
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell{
            let indexPath = tableView.indexPathForCell(cell)!
            currentContact = contacts[indexPath.row]
        }

        
        
        if let dvc = segue.destinationViewController as? DetailTableViewController {
            dvc.contact = currentContact
            dvc.delegete = self
        }
    }


}
