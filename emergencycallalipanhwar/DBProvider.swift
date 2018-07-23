//
//  DBProvider.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 6/6/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class DBProvider: NSObject {

    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef:DatabaseReference {
        return Database.database().reference()
    }
    var requestRef:DatabaseReference {
        return dbRef.child(Constants.EMERGENCY_REQUEST)
    }
    var requestAcceptedRef:DatabaseReference {
        return dbRef.child(Constants.EMERGENCY_ACCEPTED)
    }
    var requestCancelled:DatabaseReference {
        return dbRef.child(Constants.CANCELLED)
    }
    
}
