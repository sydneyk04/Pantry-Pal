//
//  LoginViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/29/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class LoginViewController: UIViewController, FUIAuthDelegate {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If user is logged in, go straight to profile page
        if let currUser = Auth.auth().currentUser {
            performSegue(withIdentifier: "goHome", sender: self)
        }
    }
    

    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        guard error == nil else{
            print("nil error")
            return
        }
        
  
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
