//
//  EmergencyHandler.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 6/6/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit

protocol EmergencyController {
    func driverAcceptyedRequest(requestAccepted:Bool,driverName:String)
}

class EmergencyHandler: NSObject {
    private  static let _instance = EmergencyHandler()
    
    var delegate: EmergencyController?
    
    var rider = ""
    var driver = ""
    var rider_Id = ""
    
    static var Instance: EmergencyHandler {
        return _instance
    }
    
    func requestEmergency(lat:Double,long:Double){
        let data:[String:Any] = [Constants.NAME:rider,Constants.LATITUDE:lat,Constants.LONGITUDE:long]
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
    }
    func observeMessagesForDriver(){
        DBProvider.Instance.requestAcceptedRef.observe(.childAdded) { (snap) in
            if let data = snap.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if self.driver == "" {
                        self.driver = name
                        self.delegate?.driverAcceptyedRequest(requestAccepted: true, driverName: self.driver)
                    }
                }
            }
        }
    }
    
    
}
