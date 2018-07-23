//
//  MapViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/24/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON
import GeoFire
import Firebase
import FirebaseAuth
import FirebaseAnalytics
import NVActivityIndicatorView

var myLocation:CLLocation?



class MapViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{

    @IBOutlet weak var CallDriverView: UIButton!
    @IBOutlet weak var activit: NVActivityIndicatorView!
    @IBOutlet weak var ambulance: UILabel!
    @IBOutlet weak var DriverName: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var callDrive: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var emergencyCall: UIButton!
    @IBOutlet weak var menu: UIButton!
    @IBOutlet weak var map1: GMSMapView!
    @IBOutlet weak var cancel1: UIButton!

    var value = 0.0
    var timer:Timer!
   
    var latitude: Double!
    var longitude: Double!

    var lat = 37.332239
    var long = -122.030822
    var locationManager = CLLocationManager()
    
    var geoFireRef:DatabaseReference?
    var geoFire:GeoFire?
    let stdZoom: Float = 12
    var didFindMyLocation = false
    var Alive = false
    
    let userId = Auth.auth().currentUser?.uid
    var polyline = GMSPolyline()
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var marker = GMSMarker()
    var str = ""

    var currentPositionMarker = GMSMarker()
    let currentLocationMarker = GMSMarker()
    var startLocation1:CLLocationCoordinate2D?
    var DriversMarker:CLLocationCoordinate2D?
    var marker2:CLLocationCoordinate2D?
    var location:CLLocation?
    
    var Hospital1 = ""
    var Hospital2 = ""
    var Hospital3 = ""
    var Hospital4 = "Kaiser Permanente"
    
    
let ref = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
    

        cancel.isHidden = true
        loadingView.isHidden = true
        userView.isHidden = true
        callDrive.isHidden = true

        self.map1.delegate = self
       
        // User Location
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        //map1.isMyLocationEnabled = true
        self.map1.isMyLocationEnabled = true
        
        Database.database().reference().child("drivers").queryOrdered(byChild: userId!).observe(.childAdded) { (snap) in
            print("values",snap)
           
        }
        self.callDrive.setTitle("No Available Ambulances", for: .normal)
        self.callDrive.sizeToFit()
        self.callDrive.isEnabled = false
        
        Database.database().reference().child("AcceptedRequest").queryOrdered(byChild: "AcceptedRequestFor").queryEqual(toValue: userId).observe(.childAdded) { (snap) in
            print("snap",snap.value)
            
            
            let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "call") as! EmergencyRequestViewController
            self.present(viewcontroller, animated: true, completion: nil)
            
        }
        
        Database.database().reference().child("AcceptedRequest").queryOrdered(byChild: "AcceptedRequestFor").queryEqual(toValue: userId).observe(.childAdded) { (snap) in
            
            Database.database().reference().child("AcceptedRequest").child(snap.key).observe(.childRemoved, with: { (snap) in
                self.activit.stopAnimating()
                self.cancel1.isHidden = true
                self.callDrive.isHidden = false
                self.userView.isHidden = true
                self.CallDriverView.isHidden = true
                self.map1.clear()
                let alert = UIAlertController(title: "Request was Cancelled", message: "Driver has cancelled the request for some reason", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction:UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            })
            
            
            
        }
        
        
    }
    func updateCurrentPositionMarker(currentLocation: CLLocationCoordinate2D) {
        self.currentPositionMarker.map = nil
        self.currentPositionMarker = GMSMarker(position: currentLocation)
        self.currentPositionMarker.icon = GMSMarker.markerImage(with: UIColor.cyan)
        self.currentPositionMarker.map = self.map1
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation1 = locations.last
        let locations12 = locations.last!
        let location1 = CLLocation(latitude: (userLocation1?.coordinate.latitude)!, longitude: (userLocation1?.coordinate.longitude)!)
         let location3 = CLLocation(latitude: (userLocation1?.coordinate.latitude)!, longitude: (userLocation1?.coordinate.longitude)!)
     //   let loc = CLLocationCoordinate2DMake((userLocation1?.coordinate.latitude)!, (userLocation1?.coordinate.longitude)!)
       // let loc1 = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
        myLocation = location1
        location = location3

        
        
     //   updateCurrentPositionMarker(currentLocation: loc)
        let location2 = CLLocationCoordinate2D(latitude: (userLocation1?.coordinate.latitude)!, longitude:(userLocation1?.coordinate.longitude)!)


//        self.latitude = locations12.coordinate.latitude
//        self.longitude = locations12.coordinate.longitude
//
//        // 2
//        let coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
//        let marker = GMSMarker(position: coordinates)
//        marker.title = "I am here"
//        marker.map = self.map1
//        self.map1.animate(toLocation: coordinates)
        
        startLocation1 = location2
        myLocation = location1
        let camera = GMSCameraPosition.camera(withLatitude: (userLocation1?.coordinate.latitude)!,longitude: (userLocation1?.coordinate.longitude)!, zoom: 13.0)
        map1.camera = camera
        self.map1?.animate(to: camera)

        
        geoFireRef = Database.database().reference().child("onlinePatients")
        
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        geoFire?.setLocation(location1, forKey: userId!)
        
    
        

    
        

            
        

        locationManager.stopUpdatingLocation()



    }



    


    func drawPath(startLocation: CLLocationCoordinate2D, endLocation: CLLocationCoordinate2D)
    {
        let origin = "\(startLocation.latitude),\(startLocation.longitude)"
        let destination = "\(endLocation.latitude),\(endLocation.longitude)"


        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"

        Alamofire.request(url).responseJSON { response in

            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result as Any)   // result of response serialization


             let json = try! JSON(data: response.data!)
             let routes = json["routes"].arrayValue


            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                self.polyline = GMSPolyline.init(path: path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.red
                self.polyline.map = self.map1
                
                
                }



        }
        

    }
    

    
 


    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        if requestAccepted {
            UserRequest(title: "Emergency Accepted", message: "\(driverName) accepted your Emergency")
            self.activit.stopAnimating()
            self.callDrive.isHidden = true
            
        }else {
            UserRequest(title: "the request was cancelled", message: "")
        }
    }
    private func UserRequest(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (alertAction: UIAlertAction) in
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
       
    }
   
    @IBAction func CallDriveButton(_ sender: Any) {
 
       
       
        self.activit.type = .ballScaleMultiple
        self.activit.color = UIColor.red
        activit.startAnimating()
        self.cancel1.isHidden = false
        NVActivityIndicatorPresenter.sharedInstance.setMessage("done")
        
        Database.database().reference().child("Patient").child(userId!).observeSingleEvent(of: .value) { (snapshot) in
            if let dic = snapshot.value as? [String:Any]{
                let name = dic["name"] as? String
                let email = dic["email"] as? String
                let values = ["emergencyRequestFrom":self.userId,"name":name,"contact":email]
                Database.database().reference().child("EmergencyRequest").child(self.userId!).setValue(values)
                self.geoFireRef = Database.database().reference().child("EmergencyRequest")
                
                self.geoFire = GeoFire(firebaseRef: self.geoFireRef!)
                self.geoFire?.setLocation(myLocation!, forKey: self.userId!)
            }
        }
        
        
        
        
        
        
        
       
        
        
    }

    

    @IBAction func emergencyCallButton(_ sender: Any) {
        emergencyCall.isHidden = true
        
        let marker = GMSMarker()
       
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        geoFireRef = Database.database().reference().child("onlineDrivers")
        geoFire = GeoFire(firebaseRef: geoFireRef!)
        let geo = geoFire?.query(at: myLocation!, withRadius: 1000)
      
         geo?.observe(.keyEntered, with: { (key:String, location:CLLocation) in
            print("key",key,"location",location)
            
            let position = CLLocationCoordinate2D(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
            let positon2 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            marker.position = position
            marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "logo-1"), scaledToSize: CGSize(width: 60.0, height: 60.0))
            marker.map = self.map1
            self.DriversMarker = marker.position
           self.marker2 = position
            self.callDrive.isEnabled = true
            self.callDrive.setTitle("Call Drive", for: .normal)
            self.callDrive.sizeToFit()
            
            
        })
        
 
        
        
        
        
        geo?.observe(.keyExited, with: { (key:String, location:CLLocation) in
            let position = CLLocationCoordinate2D(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
            marker.position = position
            marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "logo-1"), scaledToSize: CGSize(width: 60.0, height: 60.0))
            marker.map = nil
            self.callDrive.isEnabled = false
            self.cancel1.isHidden = true
            self.activit.stopAnimating()
            let alert = UIAlertController(title: "No Ambulances", message: "sorry no ambulances are available to contact", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.callDrive.setTitle("No Available Ambulances", for: .normal)
            self.callDrive.sizeToFit()
            self.userView.isHidden = true
            self.map1.clear()
            Database.database().reference().child("EmergencyRequest").child(self.userId!).removeValue()
            
        })
        


       
    }


    @objc func update(){
        value = value + 0.01
        
        loadingView.isHidden = false
        cancel.isHidden = false
        
        if value >= 1.0{
            timer.invalidate()
            timer = nil
            loadingView.isHidden = true
            cancel.isHidden = true
            callDrive.isHidden = false
            
        }
        
    }

    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.cancel.isHidden = true
        self.loadingView.isHidden = true
        if self.cancel.isHidden == true {
            self.emergencyCall.isHidden = false
        }

    }
    @IBAction func cancelButton1(_ sender: Any) {
       
        let alert = UIAlertController(title: "Messege", message: "Are you sure you want to cancel", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let cancelCall = UIAlertAction(title: "Cancel Ambulance", style: .destructive) { (action) in
            self.cancel1.isHidden = true
            self.callDrive.isHidden = false
            self.userView.isHidden = true
            self.emergencyCall.isHidden = true
            self.polyline.map = nil
            self.userView.isHidden = true
            Database.database().reference().child("EmergencyRequest").child(self.userId!).removeValue()
            Database.database().reference().child("AcceptedRequest").queryOrdered(byChild: "AcceptedRequestFor").queryEqual(toValue: self.userId).observe(.childAdded, with: { (snap) in
                Database.database().reference().child("AcceptedRequest").child(snap.key).removeValue()
            })
            
        }
        alert.addAction(cancel)
        alert.addAction(cancelCall)
        self.present(alert, animated: true, completion: nil)
        self.activit.stopAnimating()
        
        
     }

    
    @IBAction func getDirections(Segue: UIStoryboardSegue) {
        if Segue.identifier == "Emergency1" {
            let source = Segue.source as? EmergencyRequestViewController
            self.geoFireRef = Database.database().reference().child("onlineDrivers")
            self.geoFire = GeoFire(firebaseRef: self.geoFireRef!)
            
            Database.database().reference().child("AcceptedRequest").queryOrdered(byChild: "AcceptedRequestFor").queryEqual(toValue: userId).observe(.childAdded) { (snap) in
                self.geoFire?.getLocationForKey(snap.key, withCallback: { (location, error) in
                    Database.database().reference().child("drivers").child(snap.key).observe(.value, with: { (snap) in
                        guard let value = snap.value as? [String:AnyObject] else {return}
                        guard let name2 = value["name"] as? String else {return}
                        guard let ambulance2 = value["ambulance"] as? String else {return}
                        self.DriverName.text = name2
                        self.ambulance.text = ambulance2
                    })
                    if (error != nil) {
                        print("An error occurred getting the location for \"firebase-hq\": \(error?.localizedDescription)")
                    } else if (location != nil) {
                        print("Location for \"firebase-hq\" is [\(location?.coordinate.latitude), \(location?.coordinate.longitude)]")
                        let location2 = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
                        
                        let marker = GMSMarker()
                        marker.position = location2
                        marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "logo-1"), scaledToSize: CGSize(width: 60.0, height: 60.0))
                        marker.map = self.map1
                        self.drawPath(startLocation: location2, endLocation: self.startLocation1!)
                        
                        self.activit.stopAnimating()
                        self.userView.isHidden = false
                        self.cancel1.isHidden = false
                        self.CallDriverView.isHidden = false
                        self.callDrive.isHidden = true
                        
                    } else {
                        print("GeoFire does not contain a location for \"firebase-hq\"")
                    }
                })
                
                self.geoFireRef = Database.database().reference().child("onlineDrivers")
                self.geoFire = GeoFire(firebaseRef: self.geoFireRef!)
                let geo1 = self.geoFire?.query(at: self.location!, withRadius: 0.5)
                geo1?.observe(.keyEntered, with: { (key:String, location:CLLocation) in
                    print("key",key,"location",location)
                    let marker = GMSMarker()
                    let position = CLLocationCoordinate2D(latitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude))
                    
                    marker.position = position
                    marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "logo-1"), scaledToSize: CGSize(width: 60.0, height: 60.0))
                    marker.map = self.map1
                    self.marker2 = position
                    
                    self.userView.isHidden = true
                    self.cancel1.isHidden = true
                    self.CallDriverView.isHidden = true
                    
                    let viewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "arrived") as! AmbulanceArrivedViewController
                    self.present(viewcontroller, animated: true, completion: nil)
                    
                })
//                if self.Hospital4 == "Kaiser Permanente" {
//                    let marker = GMSMarker()
//                    marker.position = CLLocationCoordinate2D(latitude: 37.326519 , longitude: -122.031933)
//                    marker.icon = self.imageWithImage(image: #imageLiteral(resourceName: "hospital"), scaledToSize: CGSize(width: 60.0, height: 60.0))
//                    marker.map = self.map1
//                    self.userView.isHidden = false
//                    self.cancel1.isHidden = false
//                    self.drawPath(startLocation: self.startLocation1!, endLocation: marker.position)
//                }
                //                print("snapshot1\(snap)")
                
            }
            
            
        }
    }
    @IBAction func CallDriverButton(_ sender: Any) {
      self.Alive = true
        self.str = "a"
        
        let url:NSURL = URL(string: "TEL://\(0323231484)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
       

    }

    


    
}





    

