//
//  MapViewController.swift
//  Social
//
//  Created by Matthew Lee on 20/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol MapViewControllerDelegate {
    func mapViewController(dvc: MapViewController, contact: Contact)
}


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var geoCoder: CLGeocoder!
    var contact: Contact!
    var delegate: MapViewControllerDelegate!
    
    override func viewDidLoad() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        geoCoder = CLGeocoder()
        
        
        super.viewDidLoad()
        
        
    }

    override func viewDidAppear(animated: Bool) {
        AddressTextField.text = contact.address
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        let allow: Bool
        
        switch status {
            
        case .NotDetermined:
            allow = false
            
        case .Restricted:
            allow = false
            
        case .Denied:
            allow = false
            
        case .AuthorizedAlways:
            allow = true
            
        case .AuthorizedWhenInUse:
            allow = true
            
        }
        
        if allow{
            
                setLocation()
            
        }
      
        
    }
    
    func setLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        let address = contact.address
        
        geoCoder.geocodeAddressString(address) { array, error in
            if let placemarks = array as? [CLPlacemark] where placemarks.count > 0 {
                let placemark = placemarks[0]
                let location = placemark.location
                let coordinates = location.coordinate
                let coordRegion = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(1, 1))
                self.mapView.region = coordRegion
                
            }
            
        }
        
        
        
        
    }
    
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        contact.address = AddressTextField.text
        setLocation()
        textField.resignFirstResponder()
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
