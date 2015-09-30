//
//  SocialMediaAccount.swift
//  Social
//
//  Created by Matthew Lee on 17/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import Foundation

/**
    Class represents a social media account

    :param: identifier Media Address
    :param: type Media type
    :param: entries Array of TimelineEntries

*/

class SocialMediaAccount {
    
    var identifier: String
    var type: String
    var entries: [TimelineEntry]
    var contact: Contact!
    
    init(){
        self.identifier = ""
        self.type = ""
        self.entries = []
        //self.contact
    }
    
    
    
    
    
    
}

protocol PropertyListAccountW { func writeToFile(path: String, atomically useAuxiliaryFile: Bool) -> Bool
    
}

//Constants for Dictionary Keys
private let IdenKey = "Ident"
private let TypeKey = "Type"
private let TimeKey = "TimeLine"



//Property list extention to Contact class
extension SocialMediaAccount {
    
    //Function to Store instance of a Contact as NSDictionary (property list)
    func propertyListRepAccount() -> NSDictionary {
        let pld: NSDictionary = [
            IdenKey : identifier,
            TypeKey : type,
            TimeKey : entries,
            
        ]
        return pld
    }
    //Convenience init for reading from property list
    convenience init(PropertyListAccount: NSDictionary){
        self.init()
        if let id  = PropertyListAccount.objectForKey(IdenKey) as? String {
        self.identifier = id
        self.type = PropertyListAccount.objectForKey(TypeKey) as! String
        self.entries = PropertyListAccount.objectForKey(TimeKey) as! Array
        
        }
    }
    
}



























