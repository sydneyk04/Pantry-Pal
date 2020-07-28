//
//  SearchViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/23/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func searchButtonDidTapped(_ sender: UIButton) {
        if let search = searchTextField.text {
            SearchModel.shared.query = search
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
        self.searchTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    // Checking for entry in search field, passes to use in API call
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if searchTextField.text?.isEmpty == true {
            return false
        }
        else{
            if let search = searchTextField.text  {
                SearchModel.shared.query = search
            }
            return true
        }
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let recipeListVC = segue.destination as? RecipeListViewController {

        }
     
    }
    
}
