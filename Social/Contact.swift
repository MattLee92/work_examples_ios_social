//
//  Contact.swift
//  PhotoCollection
//
//  Created by Matthew Lee on 17/05/2015.
//  Student ID: s2818045
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import Foundation

//Queue to dispatch to from aysnc download
var mainQueue = dispatch_get_main_queue()

class Contact {
    // Varialbes of Contact
    var firstName: String
    var lastName: String
    var address: String
    var imageURL: String
    var image: NSData?
    var sites: [SocialMediaAccount]
    
    
    
    
    
    //Initialise variables
    init(){
        self.firstName = "First Name"
        self.lastName = "Last Name"
        self.address = ""
        self.imageURL = ""
        self.image = nil
        self.sites = []
    }
        
    //Downloads data from given URL and converts to image
    func loadimage(completionhandler: (data: NSData?) -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        dispatch_async(queue) {
            if let url = NSURL(string: self.imageURL){
                if let data = NSData(contentsOfURL: url) {
                    dispatch_async(mainQueue){
                    self.image = data
                    completionhandler(data: data)
                    }
                    return
                }
            }
            dispatch_async(mainQueue){
            completionhandler(data: nil)
            }
        }
    }
    
}

protocol PropertyList { func writeToFile(path: String, atomically useAuxiliaryFile: Bool) -> Bool
    
}

//Constants for Dictionary Keys
private let fNameKey = "Fname"
private let lNameKey = "Lname"
private let addressKey = "Address"
private let imageUrlKey = "ImageUrl"
private let imageKey = "Image"
private let sitesKey = "Sites"


//Property list extention to Contact class
extension Contact {
    
    //Function to Store instance of a Contact as NSDictionary (property list)
    func propertyListRep() -> NSDictionary {
        let pld: NSDictionary=[
            fNameKey : firstName,
            lNameKey : lastName,
            addressKey : address,
            imageUrlKey : imageURL,
           // imageKey : image!,
            sitesKey : sites
        ]
        return pld
    }
    //Convenience init for reading from property list
    convenience init(PropertyList: NSDictionary){
        self.init()
        firstName = PropertyList.objectForKey(fNameKey) as! String
        lastName = PropertyList.objectForKey(lNameKey)as! String
        address = PropertyList.objectForKey(addressKey) as! String
        imageURL = PropertyList.objectForKey(imageUrlKey) as! String
        image = PropertyList.objectForKey(imageKey) as? NSData
        sites = PropertyList.objectForKey(sitesKey) as! Array
        
    }
}






