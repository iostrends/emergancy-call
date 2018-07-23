//
//  EmergencyRequestViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad Ali Panhwar on 7/5/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import GeoFire
import NVActivityIndicatorView

var a = ""
var KMTravelled = ""


class EmergencyRequestViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    let userId = Auth.auth().currentUser?.uid
    
  
    var geoFireRef:DatabaseReference?
    var geoFire:GeoFire?
    var controller = MapViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        Database.database().reference().child("AcceptedRequest").observe(.childAdded) { (snap) in
            
            Database.database().reference().child("drivers").child(snap.key).observe(.value, with: { (snap) in
                guard let value = snap.value as? [String:AnyObject] else {return}
                guard let name2 = value["name"] as? String else {return}
                guard let ambulance2 = value["email"] as? String else {return}
                print("name1\(name2)")
                self.name.text = name2
                self.contact.text = ambulance2
                
            })
            
            


            
            self.geoFireRef = Database.database().reference().child("onlineDrivers")
            self.geoFire = GeoFire(firebaseRef: self.geoFireRef!)
            
            
            
            
            let geo = self.geoFire?.query(at: myLocation!, withRadius: 1000)
            geo?.observe(.keyEntered, with: { (key:String, location:CLLocation) in
                let coordinate0 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let coordinate1 = CLLocation(latitude: (myLocation?.coordinate.latitude)!, longitude: (myLocation?.coordinate.longitude)!)
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                let KM = distanceInMeters/1000
                let round1 = Double(round(1000*KM)/1000)

                self.distance.text = "\(round1) Km"
                KMTravelled = "\(round1) Km"
                self.distance.sizeToFit()
                print("dis",distanceInMeters)
            })



        }
        

        Database.database().reference().child("AcceptedRequest").queryOrdered(byChild: "AcceptedRequestFor").queryEqual(toValue: userId).observe(.childRemoved) { (snap) in
            
            
            let alert = UIAlertController(title: "Request was Cancelled", message: "\(self.name.text!) has cancelled your request call another Ambulance", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction:UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }


    
   
    
    @IBAction func Cancel(_ sender: Any) {
        Database.database().reference().child("AcceptedRequest").child(a).removeValue()
        
        self.dismiss(animated: true, completion: nil)
    }
    


    


    

}
