//
//  countryselectionViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/21/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import CountryPickerView
import Firebase
import FirebaseAuth
class countryselectionViewController: UIViewController {
    let delegate = UIApplication.shared.delegate as! AppDelegate

    let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
    @IBOutlet weak var countryselectTextfield: UITextField!
     weak var cpvTextField: CountryPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        countryselectTextfield.leftView = cp
        countryselectTextfield.leftViewMode = .always
    
        
        

    }
    
    @IBAction func continueButton(_ sender: Any) {
       
      
        
        let alert = UIAlertController(title: "⚠️", message: "Confirm your mobile number \(self.cp.selectedCountry.phoneCode)\(self.countryselectTextfield.text!)" , preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            switch action.style{
            case .default:
                PhoneAuthProvider.provider().verifyPhoneNumber("\(self.cp.selectedCountry.phoneCode)\(self.countryselectTextfield.text!)", uiDelegate: nil) { (verificationID, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    UserDefaults.standard.set(verificationID, forKey: "verification")
                    self.performSegue(withIdentifier: "verify", sender: self)
                }
            case .cancel:
                self.dismiss(animated: true, completion: nil)
            case .destructive:
                print("dest")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        delegate.numberData = "\(cp.selectedCountry.phoneCode)\(self.countryselectTextfield.text!)"
     
    }
    


}
