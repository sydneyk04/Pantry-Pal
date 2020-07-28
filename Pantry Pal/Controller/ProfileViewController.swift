//
//  ProfileViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/29/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    public var favoriteIds: [Int] = []
    public var favoriteRecipes: [Recipe] = []
    public var uid = ""
    public var image: UIImage?
//
    public var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profile")
        getUserDoc()
        addTapGesture()
        createRecipesArray()
        
        // Do any additional setup after loading the view.
    }

    // Sign out current User
    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out")
        }
        performSegue(withIdentifier: "toSearch", sender: self)
    }
    
    // Get current user id
    func currentUser() -> String {
        return uid
    }
    
    // Get signed in user doc from database
    func getUserDoc(){
        if let currUser = Auth.auth().currentUser {
            uid  = currUser.uid
        }
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(uid)
        userDoc.getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists { // force unwrap ok b/c checked for nil first
                    //let data = document.data()
                    DispatchQueue.main.async{
                    self.user = User(uid: document!.get("uid") as! String,
                                     email: document!.get("email") as! String,
                                     firstname: document!.get("firstname") as! String,
                                     lastname: document!.get("lastname") as! String,
                                     favorites: document!.get("favorites") as! [Any])
                    self.setGreetingLabel()
                }
                }
            }
            else {
                print("error")
            }
        }
    }
    
    // Set labels in view
    func setGreetingLabel() {
        
        if let user = user {
            greetingLabel.text = "Welcome!"
            nameLabel.text = "\(user.firstname) \(user.lastname)"
            emailLabel.text = "E-mail: \(user.email)"
            if let currentUser = Auth.auth().currentUser {
                if let photo = currentUser.photoURL?.absoluteString {
                    profileImage.kf.setImage(with: URL(string: photo))
                }
            }
        }
    }
    
    // Tap gesture for profile picture
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        self.profileImage.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized (recognizer: UITapGestureRecognizer) {
       let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }

    // Image Picker used to choose profile picture, saves imageURL to Firebase
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            let storageRef = Storage.storage().reference().child("profileImage")
            
            if let uploadData = image.pngData() {
                storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        print(error)
                    }
                    storageRef.downloadURL { (imageURL, error) in
                        if error != nil{
                            print(error)
                        }
                         let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                         changeRequest?.photoURL = imageURL
                        print(imageURL)
                         changeRequest?.commitChanges(completion: { (error) in
                         })
                    }

                }
            }
            
                
        } else {
            print("image picker error")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Creates array of current user favorite recipes to be used in table
     func createRecipesArray() {
        RecipeModel.shared.favoriteRecipes.removeAll()
            let db = Firestore.firestore()
                  if let currUser = Auth.auth().currentUser{
                      let docRef = db.collection("users").document(currUser.uid)
                      docRef.getDocument { (document, error) in
                          if let error = error {
                              print(error)
                              return
                          }
                          self.favoriteIds = document!.get("favorites") as! [Int]
                          for id in self.favoriteIds{
                              let recipeDoc = db.collection("recipes").document(String(id))
                              recipeDoc.getDocument { (recipeDocument, error2) in
                                  if let error2 = error2 {
                                      print(error2)
                                  }
                                  if recipeDocument!.exists{
                                      let recipe =  Recipe(id: recipeDocument!.get("id") as! Int,
                                                        image: recipeDocument!.get("image") as! String,
                                                        servings: recipeDocument!.get("servings") as! Int,
                                                        sourceUrl: recipeDocument!.get("sourceUrl") as! String,
                                                        readyInMinutes: recipeDocument!.get("readyInMinutes") as! Int,
                                                        title: recipeDocument!.get("title") as! String)
                                    
                                    RecipeModel.shared.favoriteRecipes.append(recipe)
                                  } else {
                                      print("recipe doc does not exist")
                                  }
                              }
                          }
                              
                      }
                  }
         
        }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let favoritesVC = segue.destination as? FavoritesTableViewController {
            print(favoriteRecipes)
            favoritesVC.favoriteRecipes = RecipeModel.shared.favoriteRecipes
        }
    }
    

}
