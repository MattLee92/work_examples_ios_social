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
        LoadFromFile()
        println(contacts.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }

    //Action to add new contact to model
    @IBAction func AddContact(sender: AnyObject) {
        currentContact = Contact()
        contacts.append(currentContact)
       performSegueWithIdentifier("ShowDetail", sender: self)
       
        
        
    }
    override func viewDidAppear(animated: Bool) {
        SaveToFile()
    }
    
    
    /**
    Function Saves current contacts to file
    
    
    
    */
    private func SaveToFile(){
        println("SAVE")
        println(contacts.count)
        
        let arrayPLIST: NSArray = contacts.map { $0.propertyListRep()}
        //Get the file path and name
        println(arrayPLIST[0])
        let saveDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        let fileName = saveDir.stringByAppendingPathComponent("contacTdata.plist")
        //Write array to file
            println(arrayPLIST.count)
        arrayPLIST.writeToFile(fileName, atomically: true)
       
        
        }
    
    /**
    Function Loads contacts from file
    
    
    */
    private func LoadFromFile() {
        println("LOAD")
        //Get the file path and name
         let saveDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
             let fileName = saveDir.stringByAppendingPathComponent("contacTdata.plist")
        
         let fileContent = NSArray(contentsOfFile: fileName) as! Array<NSDictionary>
            let arrayReadContacts = fileContent.map{ Contact(PropertyList: $0)}
        
            println(arrayReadContacts.count)
            contacts = arrayReadContacts
            //Refresh the colletion data
        
    }
        
    

    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return contacts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        println("RELAOD")
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
       // tableView.reloadData()
        
    }
    
    
    
    func detailViewController(dvc: DetailTableViewController, contact: Contact){
        navigationController?.popToViewController(self, animated: true)
        SaveToFile()
        tableView.reloadData()
    }
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            contacts.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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
