//
//  AmbulanceArrivedViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad Ali Panhwar on 7/19/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit

class AmbulanceArrivedViewController: UIViewController{


    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    var dis:String?
    var time1:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  


        self.distance.text = KMTravelled
        
        let date = Date()
        let calander = Calendar.current
        let hours = calander.component(.hour, from: date)
        let minutes = calander.component(.minute, from: date)
        self.time.text = "\(hours):\(minutes)"
        
    }
    





    @IBAction func HospitalButton(_ sender: Any) {
        
    }

    

}
