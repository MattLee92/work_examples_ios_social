//
//  TimelineEntry.swift
//  Social
//
//  Created by Matthew Lee on 17/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import Foundation
import Social

class TimelineEntry {
    
    var image: NSData?
    var siteData: String
    var text: String
    
    
    init(){
        self.image = nil
        self.siteData = ""
        self.text = ""
    }
    
    
    
    
    //Downloads data from given URL and converts to image
    func loadSocialimage(completionhandler: (data: NSData?) -> Void) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        dispatch_async(queue) {
            if let url = NSURL(string: self.siteData){
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