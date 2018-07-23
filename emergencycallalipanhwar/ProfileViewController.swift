//
//  ProfileViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad Ali Panhwar on 7/2/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit
import Firebase
struct User {
    var name:String?
    var lastName:String?
    var email:String?
    var birth:String?
}
var users:[User] = []
class ProfileViewController: UIViewController {

    let picker = UIDatePicker()
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var lastNameText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var DateOfBirthText: UITextField!
    @IBOutlet weak var GenderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createDatePicker()
        let uid = Auth.auth().currentUser?.uid
       
        Database.database().reference().child("Patient").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dic = snapshot.value as? [String:Any]{
                let name = dic["name"] as? String
                let email = dic["email"] as? String
                let gender = dic["isMale"] as? Bool
                let lastName = dic["lastName"] as? String
                let birth = dic["birth"] as? String
                
                
                let users1 = User(name: name, lastName: lastName, email: email, birth: birth)
                users.append(users1)
                
                self.nameText.text = name
                self.emailText.text = email
                self.DateOfBirthText.text = birth
                self.lastNameText.text = lastName
                
                if gender == true {
                    self.GenderLabel.text = "Male"
                }else {
                    self.GenderLabel.text = "Female"
                }
                
            }
            
        }, withCancel: nil)
        
    }
   
    @IBAction func editName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit",
                                      message: "edit your name here",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "\(users[0].name!)"
            textField.clearButtonMode = .whileEditing
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            print(textField.text!)
            self.nameText.text = textField.text
        })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editLastName(_ sender: Any) {
        let alert = UIAlertController(title: "Edit",
                                      message: "edit your last name here",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "\(users[0].lastName!)"
            textField.clearButtonMode = .whileEditing
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            print(textField.text!)
            self.lastNameText.text = textField.text
        })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func editEmail(_ sender: Any) {
        let alert = UIAlertController(title: "Edit",
                                      message: "edit your email here",
                                      preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "\(users[0].email!)"
            textField.clearButtonMode = .whileEditing
            
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            print(textField.text!)
            self.emailText.text = textField.text
        })
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editDateOfBirth(_ sender: Any) {

        
    }
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        DateOfBirthText.text = "\(dateString)"
        self.view.endEditing(true)
    }
    func createDatePicker(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([done], animated: false)
        DateOfBirthText.inputAccessoryView = toolBar
        DateOfBirthText.inputView = picker
        
        
        picker.datePickerMode = .date
    }
  
    @IBAction func menu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
