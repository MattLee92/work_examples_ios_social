//
//  SocialCollectionViewController.swift
//  Social
//
//  Created by Matthew Lee on 23/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class SocialCollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var contact: Contact!
    var entries = Array<TimelineEntry>()
    var photoList = [FlickrPhoto]()
    var thumbnailList = [UIImage?]()
    
    
    
    @IBAction func Reloa(sender: AnyObject) {
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrAPIKey = "c5a55c321772d09421c792f678a5323e"
  
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // collectionView?.dataSource = self
       // collectionView?.delegate = self
        
        // Register cell classes
        self.collectionView!.registerClass(SocialCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        collectionView?.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //if let photos = photosForUser("ext-or", maximumResults: 20){
        if let photos = latestFlickrPhotos(maximumResults: 1){
        photoList = photos
        thumbnailList = photos.map { photo in nil }
        collectionView?.reloadData()
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)){
                for var i = 0; i < photos.count ; i++ {
                    let photo = photos[i]
                    if let flickrURL = url(photo, format: FlickrPhotoFormatThumbnail), data = NSData(contentsOfURL: flickrURL), image = UIImage(data: data){
                        let j = i
                        dispatch_async(dispatch_get_main_queue()){
                            self.thumbnailList[j] = image
                            //self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forRow: j, inSection: 0)])
                            
                
                        }
                    }else{
                        println("ERROR VIEw WILL")
                    }
             
                }
            }
        } else {
            println("Not photos")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return photoList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!SocialCollectionViewCell
       
        println(thumbnailList.count)
    
       // let flickrPhoto = photoList[indexPath.item]
      
        //cell.imageView.image =
        if thumbnailList.count > indexPath.row {
            if let image = thumbnailList[indexPath.row] {
            
            cell.imgV.image = image
                
            } else {
                println("ERROR TABLE")
        }
            
        } else {
            println("Fail Count")
        }
        
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
