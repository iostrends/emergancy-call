//
//  SignUpViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/23/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import BEMCheckBox


class SignUpViewController: UIViewController {

    let picker = UIDatePicker()
    
    var ref: DatabaseReference!

    var isMale:Bool?

    
    @IBOutlet weak var female: BEMCheckBox!
    @IBOutlet weak var male: BEMCheckBox!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birth: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var upperSignup: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

       ref = Database.database().reference()
        addBottomLine(label: upperSignup)
        borderColor(textfield: nameTextfield)
        borderColor(textfield: lastName)
        borderColor(textfield: email)
        borderColor(textfield: birth)
       createDatePicker()
       
    
    }
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: false)
        birth.inputAccessoryView = toolBar
        birth.inputView = picker
        
        
        picker.datePickerMode = .date
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        birth.text = "\(dateString)"
        self.view.endEditing(true)
    }

    func addBottomLine(label:UILabel) {
      let layer = UIView()
        layer.backgroundColor = UIColor.red
        layer.frame = CGRect(x: 0.0, y: label.frame.height - 2.0, width: label.frame.width, height: 2.0)
        label.addSubview(layer)
    }
    func borderColor(textfield:UITextField) {
        textfield.layer.borderColor = UIColor.gray.cgColor
        textfield.layer.borderWidth = CGFloat(Float(2.0))
        textfield.layer.cornerRadius = CGFloat(Float(10.0))
        textfield.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0)
        
    }
 
    
    @IBAction func maleButton(_ sender: UIButton) {
      male.on = true
        isMale = true
        male.animationDuration = 1
        if male.on == true {
            female.on = false
        }
        
    }
    @IBAction func femaleButton(_ sender: UIButton) {
        isMale = false
      female.on = true
        if female.on == true {
            male.on = false
        }
    }
 
    @IBAction func SignUpButton(_ sender: Any) {
        
       if email.text != "" && lastName.text != "" && nameTextfield.text != "" && birth.text != "" {
      
        ref.observe(.childAdded) { (snap) in
            
        }
        let userID = Auth.auth().currentUser!.uid
        let values = ["name":nameTextfield.text!,"lastName":lastName.text!,"birth":birth.text!,"email":email.text!,"isMale":isMale] as [String : Any]
            self.ref.child("Patient").child(userID).setValue(values)
        
           
           let controller = self.storyboard?.instantiateViewController(withIdentifier: "mapView") as! MapViewController
           self.present(controller, animated: true, completion: nil)
        
       }
      
    }
    
      
 

    
 }


    
    

