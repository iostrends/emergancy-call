//
//  DrowerViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 6/5/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class DrowerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func SignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            let uid = Auth.auth().currentUser?.uid
            let online = Database.database().reference().child("onlinePatients").child(uid!)
            let online1 = Database.database().reference().child("EmergencyRequest").child(uid!)
            let online2 = Database.database().reference().child("AcceptedRequest")
            
            online1.onDisconnectRemoveValue()
            online.onDisconnectRemoveValue()
            online2.onDisconnectRemoveValue()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "phone") as! ViewController
            self.present(controller, animated: true, completion: nil)
        }catch let signOutError as NSError {
            print(signOutError)
        }
    }
    

}
