//
//  SocialTests.swift
//  SocialTests
//
//  Created by Matthew Lee on 17/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit
import XCTest

class SocialTests: XCTestCase {
    
    let maxphoto = 10
    let testCont = Contact()
    
    override func setUp() {
        FlickrAPIKey = "c5a55c321772d09421c792f678a5323e"
        testCont.firstName = "SomeFirstName"
        testCont.lastName = "SomeLastName"
        testCont.address = "Ipswich, Qld 4305"
        testCont.imageURL = "http://www.griffith.edu.au/__data/assets/image/0019/632332/gu-header-logo.png"
        testCont.sites = []
    }
    
    //Test Setters and getters for Contact Class
    func testContact(){
       
        XCTAssertEqual(testCont.firstName, "SomeFirstName")
        XCTAssertEqual(testCont.lastName, "SomeLastName")
        XCTAssertEqual(testCont.address, "Ipswich, Qld 4305")
        XCTAssertEqual(testCont.imageURL, "http://www.griffith.edu.au/__data/assets/image/0019/632332/gu-header-logo.png")
        XCTAssertNotNil(testCont.sites)
        
    }


    func testLatestFlickrPhotos() {
        let photos = latestFlickrPhotos(maximumResults: maxphoto)
        XCTAssert(photos != nil)
        XCTAssertEqual(photos!.count, maxphoto)
    
    }
    
    func testDownloadLatestFlickrPhoto() {
        let photos = latestFlickrPhotos(maximumResults: maxphoto)
        XCTAssert(photos != nil)
        XCTAssert(photos!.count > 0)
        let latestPhoto = photos![0]
        let fUrl = url(latestPhoto)
        XCTAssert(fUrl != nil)
        let data = NSData(contentsOfURL: fUrl!)
        XCTAssert(data != nil)
        let image = UIImage(data: data!)
        XCTAssert(image != nil)
        
    }
    
    
    func testDowloadAsync() {
        //Set mainQueue to a low priority backgroung queue
        mainQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
     
        //variable to determine if download is complete
        var downloadcomplete = false
        //Call loadimage function from Photo class
        testCont.loadimage { data in
            downloadcomplete = true
        }
        //Set max wait time for download
        var maxWait = 10
        
        //Loop until download complete or timeout (10 seconds)
        while !downloadcomplete && maxWait-- > 0 {
            sleep(1)
        }
        //Assert download was succesfull
        XCTAssertNotNil(testCont.image, "Could not Download")
        XCTAssertNotNil(UIImage(data: testCont.image!), "Not an Image")
        
    }
    
    
    
    
    
    
    
}
