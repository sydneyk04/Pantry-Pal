//
//  RecipeInfoViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/28/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class RecipeInfoViewController: UIViewController {

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    public var recipe: Recipe!
    
    // Opens safari to recipe URL
    @IBAction func getRecipeButtonDidPressed(_ sender: UIButton) {
        if let url = URL(string: recipe.sourceUrl) {
            UIApplication.shared.open(url)
        }
        else{
            print("source url error")
        }
    }
    
    // Removes or adds favorite to Firebase and to User data
    @IBAction func favoriteDidSwitch(_ sender: UISwitch) {
         print(Auth.auth().currentUser)
        if let currUser = Auth.auth().currentUser {
            if(favoriteSwitch.isOn){
                let db = Firestore.firestore()
                let data:[String: Any] = [
                    "id": recipe.id,
                    "image": recipe.image,
                    "servings": recipe.servings,
                    "sourceUrl": recipe.sourceUrl,
                    "readyInMinutes": recipe.readyInMinutes,
                    "title": recipe.title
                ]
                db.collection("recipes").document(String(recipe!.id)).setData(data)
                    { (err) in
                        if err != nil {
                            print(err)
                            return
                        }
                    }

                let userDoc = db.collection("users").document(currUser.uid)
                userDoc.updateData([
                    "favorites": FieldValue.arrayUnion([recipe.id])
                ])
                 print(recipe.id)
            }
            else {
                let db = Firestore.firestore()
                let userDoc = db.collection("users").document(currUser.uid)
                userDoc.updateData([
                    "favorites": FieldValue.arrayRemove([recipe.id])
                ])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.kf.setImage(with: URL(string:"https://spoonacular.com/recipeImages/\(recipe.id)-240x150.jpg"))
        recipeTitle.text = recipe.title
        servingsLabel.text = "Servings: \(recipe.servings)"
        timeLabel.text = "Total Time: \(recipe.readyInMinutes) minutes"
        
        // Sets favorite switch if logged in user has favorited the recipe
        if let currUser = Auth.auth().currentUser {
            let db = Firestore.firestore()
            let userDoc = db.collection("users").document(String(currUser.uid))
            userDoc.getDocument { (document, error) in
                if error == nil {
                    if document != nil && document!.exists {
                        
                        let favoritesArray = document!.get("favorites") as! [Int]
                        if favoritesArray.contains(self.recipe.id) {
                            self.favoriteSwitch.isOn = true
                        }
                    }
                }
            }
        }
        // Do any additional setup after loading the view.
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
