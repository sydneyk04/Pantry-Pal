//
//  SignUpFormViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/29/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpFormViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        // Do any additional setup after loading the view.
    }
    
    func setUpForm() {
        // Hide Error Label
        errorLabel.alpha = 0
    }
    
    // Check all fields are valid. Returns nil if all correct or error message if something is blank or formatted incorrectly.
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return("Please fill in your first name.")
        } else if lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           return("Please fill in your last name.")
        } else if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return("Please fill in an e-mail.")
        } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           return("Please choose a password.")
        }
        return nil
    }
    
    @IBAction func signUpDidTapped(_ sender: UIButton) {
        // Validate Form Fields
       let error = validateFields()
        
        if error != nil { // If error in form validation
            displayError(error!)
        }
        else{  // Create New User, can force unwrap because already checked for nil in validateFields
            
            // get clean variable data
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Try to create new user
            Auth.auth().createUser(withEmail: email , password: password) { (result, error) in
                
                // Check for errors when creating new user
                if error != nil {
                    print(error)
                    self.displayError("E-mail and/or Password Error")
                    return
                }
                else{
                    let db = Firestore.firestore()
                    let data:[String: Any] = [
                        "firstname": firstname,
                        "lastname": lastname,
                        "email": email,
                        "uid": result!.user.uid,
                        "favorites": []
                    ]
                    // Create document with user data
                    db.collection("users").document(result!.user.uid).setData(data)
                    { (err) in
                        if err != nil {
                            self.displayError("User document could not be created")
                            return
                        }
                        // Transition to Profile Screen
                        self.transitionToProfile(result!.user.uid)
                    }
    
                }
            }
        }
       
 
    }
    
    // Transition from Sign In Screen to Profile Screen
    func transitionToProfile(_ id:String) {
        let profileVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileVC) as? ProfileViewController
        
        profileVC?.uid = id
        view.window?.rootViewController = profileVC
        view.window?.makeKeyAndVisible()
    }

    func displayError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

}
