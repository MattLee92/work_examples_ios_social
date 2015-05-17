//
//  FlickrAPI.swift
//  Flickr Usage Example
//
//  Created by Rene Hexel on 29/04/2015.
//  Copyright (c) 2015 Rene Hexel. All rights reserved.
//

import Foundation

/// API key your requested from Flickr.
/// WARNING: YOUR PROGRAM WILL CRASH IF NOT SET
var FlickrAPIKey: String!

/// original photo as uploaded
let FlickrPhotoFormatOriginal  = "o"

/// square version of a photo (i.e. width == height)
let FlickrPhotoFormatSquare    = "s"

/// big version of a photo (but not as big as the original)
let FlickrPhotoFormatBig       = "b"

/// small version of a photo, suitable for on-screen display
let FlickrPhotoFormatSmall     = "m"

/// thumbnail version of a photo, suitable for overviews
let FlickrPhotoFormatThumbnail = "t"

/// 500 pixel version of a photo
let FlickrPhotoFormat500       = "-"

/// 640 pixel version of a photo, e.g. for a 640x480 VGA or phone screen
let FlickrPhotoFormat640       = "z"

/// by default, return 75 results maximum to avoid excessive downloads
let FlickrDefaultMaximumResults = 75

/// Photo data structure containing the most important elements of
/// a Flickr photo reference
struct FlickrPhoto {
    let id: String
    let secret: String
    let owner: String
    let title: String
    let farm: Int
    let server: String
    let originalSecret: String?
    let originalFormat: String?
}


/// download a list of the latest photos on Flickr
///
func latestFlickrPhotos(maximumResults: Int = FlickrDefaultMaximumResults) -> Array<FlickrPhoto>? {
    if let response = fetch("https://api.flickr.com/services/rest/?method=flickr.photos.search&license=1,2,4,5,7&per_page=\(maximumResults)&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url") {
        return photosForFlickrJSONResponse(response)
    }
    return nil
}


/// download a list of photos for the given user
///
/// :param: `user`: the flickr user name to download the photo list for
/// :param: `maximumResults`: the maximum number of results to return
func photosForUser(user: String, maximumResults: Int = FlickrDefaultMaximumResults) -> Array<FlickrPhoto>? {
    if let nsid = idForUser(user) {
        return photosForNSID(nsid, maximumResults: maximumResults)
    }
    return nil
}


/// download a list of photos for a given Flickr nsid
///
/// :param: `nsid`: the flickr user name to download the photo list for
/// :param: `maximumResults`: the maximum number of results to return
func photosForNSID(nsid: String, maximumResults: Int = FlickrDefaultMaximumResults) -> Array<FlickrPhoto>? {
    if let response = fetch("https://api.flickr.com/services/rest/?method=flickr.photos.search&per_page=\(maximumResults)&has_geo=1&user_id=\(nsid)&extras=original_format,tags,description,geo,date_upload,owner_name,place_url") {
        return photosForFlickrJSONResponse(response)
    }
    return nil
}


/// get the ID for a given user
///
/// :param: `user`: the flickr user name to get the ID for
func idForUser(user: String) -> String? {
    if let response = fetch("https://api.flickr.com/services/rest/?method=flickr.people.findByUsername&username=\(user)") {
        return response.valueForKeyPath("user.nsid") as? String
    }
    return nil
}


/// get photos out of a Flickr response
///
/// :param: `response`: JSON dictionary as a response for a photos REST request
func photosForFlickrJSONResponse(response: NSDictionary) -> Array<FlickrPhoto>? {
    if let photoArray = response.valueForKeyPath("photos.photo") as? Array<NSDictionary> {
        return photoArray.reduce([FlickrPhoto]()) { array, dict in
            if let photo = photo(dict) {
                return array + [photo]
            }
            return array
        }
    }
    return nil
}


/// convert a photo JSON dictionary to a `FlickrPhoto`
///
/// :param: `json`: JSON dictionary to interpret as a JSON encoded Flickr photo
func photo(json: NSDictionary) -> FlickrPhoto? {
    if let id = json["id"]     as? String,
           sc = json["secret"] as? String,
           ow = json["owner"]  as? String,
           ti = json["title"]  as? String,
           fa = json["farm"]   as? Int,
           se = json["server"] as? String {
            return FlickrPhoto(id: id, secret: sc, owner: ow, title: ti, farm: fa, server: se, originalSecret: json["originalsecret"] as? String, originalFormat: json["originalformat"] as? String)
    }
    return nil
}


/// get the URL for a photo
///
/// :param: `photo`:  flickr photo to the the access URL string for
/// :param: `format`: image format to download
func url(photo: FlickrPhoto, format: String = FlickrPhotoFormatOriginal) -> NSURL? {
    if let s = urlString(photo, format: format) {
        return NSURL(string: s)
    }
    return nil
}


/// get the URL string for a photo
///
/// :param: `photo`:  flickr photo to the the access URL string for
/// :param: `format`: image format to download
func urlString(photo: FlickrPhoto, format: String = FlickrPhotoFormatOriginal) -> String? {
    let kind: String
    let secret: String
    if format == FlickrPhotoFormatOriginal {
        if let s = photo.originalFormat, f = photo.originalFormat {
            secret = s
            kind = f
        } else {
            return nil
        }
    } else {
        kind = "jpg"
        secret = photo.secret
    }
    return "https://farm\(photo.farm).static.flickr.com/\(photo.server)/\(photo.id)_\(secret)_\(format).\(kind)"
}



/// This is the function that actually fetches data from Flickr.
/// Don't invoke directly (unless you want to extend this Flickr API),
/// use one of the public functions instead!
///
/// :param: `requestString`: string containing the REST request URL
private func fetch(requestString: String) -> NSDictionary? {
    var error: NSError?
    if let url = NSURL(string: "\(requestString)&api_key=\(FlickrAPIKey)&format=json&nojsoncallback=1"),
          data = NSData(contentsOfURL: url) {
          return NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? NSDictionary
    }
    return nil
}

