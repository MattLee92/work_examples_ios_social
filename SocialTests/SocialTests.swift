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
    
    override func setUp() {
    FlickrAPIKey = "c5a55c321772d09421c792f678a5323e"
        
    }
    
    //Test Setters and getters for Photo Class
    func testPhoto(){
        let myphoto = Photo()
        myphoto.title = "SomeTitle"
        myphoto.tags = ["sometag", "gu", "Griffith"]
        myphoto.url = "http://www.griffith.edu.au/__data/assets/image/0019/632332/gu-header-logo.png"
        XCTAssertEqual(myphoto.title, "SomeTitle")
        XCTAssertEqual(myphoto.tags, ["sometag", "gu", "Griffith"])
        XCTAssertEqual(myphoto.url, "http://www.griffith.edu.au/__data/assets/image/0019/632332/gu-header-logo.png")
    
    
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
    
}
