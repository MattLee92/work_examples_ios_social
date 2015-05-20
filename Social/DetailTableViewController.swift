//
//  DetailTableViewController.swift
//  Social
//
//  Created by Matthew Lee on 19/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit

//Delegate protocol for DetailView
protocol DetailViewControllerDelegate{
    func detailViewController(dvc: DetailTableViewController, contact: Contact)
}



class DetailTableViewController: UITableViewController, UITextFieldDelegate {

    var contact: Contact!
    var delegete: DetailViewControllerDelegate!
    var imageData: NSData?
    
    @IBOutlet weak var pictureUrlTxt: UITextField!
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var contactProfile: UIImageView!
    @IBOutlet weak var addressCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewWillAppear(animated: Bool) {
        
        firstNameTxt.text = contact.firstName
        lastNameTxt.text = contact.lastName
        pictureUrlTxt.text = contact.imageURL
        addressCell.textLabel!.text = contact.address
        loadImage()
    
        
    }
    
    
    func loadImage(){
        let conToImage: (NSData?) -> Void = {
            if let d = $0 {
                self.imageData = d
                let image = UIImage(data: d)
                self.contactProfile.image = image
            } else {
                self.contactProfile.image = nil
            }
        }
        if let d = contact.image {
            conToImage(d)
        } else {
            contact.loadimage(conToImage)
        }
        

    }
    
    
    
    
    @IBAction func saveContact(sender: AnyObject) {
        if let fn = firstNameTxt.text {
            if let ln = lastNameTxt.text {
                if let ad = addressCell.textLabel!.text  {
                    if let iu = pictureUrlTxt.text {
                        contact.firstName = fn
                        contact.lastName = ln
                        contact.address = ad
                        contact.imageURL = iu
                        contact.image = imageData
                        delegete.detailViewController(self, contact: contact)
                    }
                }
            }
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadImage()
        
        return true
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.

        if section == 1 {
            return 3  //REPLACE! with count of secial media accounts
        }else {
        
        
            return 2
        }
    
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
