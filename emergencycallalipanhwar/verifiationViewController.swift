//
//  verifiationViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/22/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import FirebaseAuth

class verifiationViewController: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var ResendView: UIButton!
    @IBOutlet weak var verifyView: UIButton!
    @IBOutlet weak var countDown: UILabel!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    

    var seconds = 60
    var seconds2 = 60//This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    override func viewDidLoad() {
        super.viewDidLoad()

        countDown.text = "\(time)"
        tf1.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        tf2.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        tf3.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        tf4.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        tf5.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        tf6.addTarget(self, action: #selector(textfieldDidChange(textfield:)), for: UIControlEvents.editingChanged)
        
        runTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tf1.becomeFirstResponder()
    }
    @objc func textfieldDidChange(textfield:UITextField) {
        let text = textfield.text
        if text?.utf16.count == 1 {
            switch textfield{
            case tf1:
                 tf2.becomeFirstResponder()
            case tf2:
                 tf3.becomeFirstResponder()
            case tf3:
                tf4.becomeFirstResponder()
            case tf4:
                tf5.becomeFirstResponder()
            case tf5:
                tf6.becomeFirstResponder()
            case tf6:
                tf6.resignFirstResponder()
            default:
                break
            }
        }
    }
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        countDown.text = "\(seconds)"
        if seconds == 0 {
            timer.invalidate()
            //self.dismiss(animated: true, completion: nil)
            self.ResendView.isHidden = false
        }
      
    }
    @objc func updateTimer2() {
        seconds2 -= 1     //This will decrement(count down)the seconds.
        countDown.text = "\(seconds2)"
        if seconds2 == 0 {
            timer.invalidate()
            //self.dismiss(animated: true, completion: nil)
            self.ResendView.isHidden = false
        }
        
    }

  
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(verifiationViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func resendButton(_ sender: Any) {
        verifyView.isHidden = false
        ResendView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verify(_ sender: Any) {
      
     let userdefuilt =  UserDefaults.standard.string(forKey: "verification")
        let credential:PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: userdefuilt!, verificationCode: "\(tf1.text!)\(tf2.text!)\(tf3.text!)\(tf4.text!)\(tf5.text!)\(tf6.text!)")
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                print(error)
                return
            }else{
                print("user number\(String(describing: user?.phoneNumber))")
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "signUp") as! SignUpViewController
                print("user Id \(String(describing: user?.providerID))")
                self.present(controller, animated: true, completion: nil)

            }
            
        }
        
    }
    
}
