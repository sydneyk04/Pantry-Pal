//
//  LoginFormViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/29/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase

class LoginFormViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpForm()
        
    }
    
    func setUpForm() {
        errorLabel.alpha = 0
    }
    
    // Checks for filled in fields
    func validateForm() -> String?{
       if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
           return("Please fill in an e-mail.")
       } else if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
          return("Please fill in password.")
       }

       return nil
    }
    
    @IBAction func loginButtonDidTapped(_ sender: UIButton) {
        // Validate Form
        let error = validateForm()
        if (error != nil){
            displayError(error!)
        } else {// Sign In User
            // clean variables
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    print(error)
                    self.displayError("Error logging in user")
                } else {
                    self.transitionToProfile(result!.user.uid)
                }
            }
        }
    }
    
    // Transition from Sign In Screen to Profile Screen
    func transitionToProfile(_ uid: String) {
        let profileVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileVC) as? ProfileViewController
        profileVC?.uid = uid
        view.window?.rootViewController = profileVC
        view.window?.makeKeyAndVisible()
    }
    
    // User facing error label
    func displayError(_ message: String){
         errorLabel.text = message
         errorLabel.alpha = 1
     }
    
}
