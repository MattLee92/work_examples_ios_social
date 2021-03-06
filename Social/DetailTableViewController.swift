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

class DetailTableViewController: UITableViewController, UITextFieldDelegate, MapViewControllerDelegate, WebViewControllerDelegate {

    var contact: Contact!
    var delegete: DetailViewControllerDelegate!
    var imageData: NSData?
    var tableCells = ["NameCell", "AddressCell", "SocialCell", "PicUrlCell", "PicImageCell"]
    var cellID: String = "NameCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    override func viewWillAppear(animated: Bool) {
        tableCells = ["NameCell", "AddressCell", "SocialCell", "PicUrlCell", "PicImageCell"]
        tableView.reloadData()
        
    }
    
    
    
    
    @IBAction func SetEdit(sender: AnyObject) {
        
    }
    
    
    @IBAction func saveContact(sender: AnyObject) {
        
        SaveCurrent()
        delegete.detailViewController(self, contact: contact)
        
    }
    
    
    
    /**
    Function saves the Current contact based on latest user input
    
    
    */
    func SaveCurrent(){
        
        if let f_name = self.tableView.viewWithTag(1) as? UITextField {
            contact.firstName = f_name.text
        }
        if let l_name = self.tableView.viewWithTag(2) as? UITextField {
            contact.lastName = l_name.text
        }
        if let picurl = self.tableView.viewWithTag(3) as? UITextField {
            contact.imageURL = picurl.text
        }
        
        
        

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
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

        if section == 1 {
            return contact.sites.count
        }else {
        
            return 2
        }
    
    }
    
    //Delegate for map and Webviews
    func mapViewController(dvc: MapViewController, contact: Contact){
        navigationController?.popToViewController(self, animated: true)
    }
    func webViewController(dvc: WebViewController, contact: Contact){
        navigationController?.popToViewController(self, animated: true)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        //super.setEditing(editing, animated: animated)
        if editing {
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: contact.sites.count, inSection: 1)], withRowAnimation: .Automatic)
        } else {
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: contact.sites.count, inSection: 1)], withRowAnimation: .Automatic)
    
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let index = tableView.indexPathForSelectedRow()
        let currCell = tableView.cellForRowAtIndexPath(index!) as UITableViewCell?
        
        if indexPath.section == 1 && currCell!.detailTextLabel?.text == "Web" {
       //     performSegueWithIdentifier("ShowSocial", sender: self)
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       //Set headers for sections
        switch(section){
        case 0:
        return "Name and Address"
        case 1:
        return "Social"
        case 2:
        return "Picture"
        default:
        return ""
        }
    }

    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //Set size of cells 260 for image 44 for others
        if indexPath.section == 2 && indexPath.row == 1{
            return 260
        } else {
            return 44
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
     
        
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! UITableViewCell
        
        //Select index section
        //Selelct index row and set data from the model
        switch (indexPath.section) {
        case 0:
            
            if indexPath.row == 0 {
                if let txtField = cell.viewWithTag(1) as? UITextField {
                    txtField.text = contact.firstName
                   
                }
                    
                if let txtField = cell.viewWithTag(2) as? UITextField {
                    txtField.text = contact.lastName
                    cellID = "AddressCell"
                }
           
            }
            
            if indexPath.row == 1 {
                cell.textLabel?.text = contact.address
                
                cellID = "SocialCell"

            }
          
            
        case 1:
            
            for site in contact.sites {
                cell.textLabel?.text = contact.sites[indexPath.row].identifier
                cell.detailTextLabel?.text = contact.sites[indexPath.row].type
                return cell
                
            }
           
            if indexPath.row >= contact.sites.count {
                cellID = "PicUrlCell"
            }
            
            

        case 2:
           
            if indexPath.row == 0 {
              
                if let txtField = cell.viewWithTag(3) as? UITextField {
                    txtField.text = contact.imageURL
                    
                    cellID = "PicImageCell"
                }
                
            } else {
                
                let conToImage: (NSData?) -> Void = {
                    if let d = $0 {
                        self.imageData = d
                        let image = UIImage(data: d)
                        
                        if let imageV = cell.viewWithTag(4) as? UIImageView {
                            imageV.image = image                        }
                        
                    } else {
                        cell.imageView!.image = nil
                    }
                }
                if let d = contact.image {
                    conToImage(d)
                } else {
                    contact.loadimage(conToImage)
                }
            }
            
        
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
    }
         return cell
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
        
        SaveCurrent()
        
        if let dvc = segue.destinationViewController as? MapViewController {
            dvc.contact = contact
            dvc.delegate = self
        }
        
        if let dvc = segue.destinationViewController as? WebViewController {
            dvc.contact = contact
            dvc.delegate = self
        }
        
        
    }
    

}


