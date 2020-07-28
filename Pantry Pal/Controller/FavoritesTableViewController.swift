//
//  FavoritesTableViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 5/5/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Firebase

class FavoritesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    
    var favoriteIds: [Int] = []
    var favoriteRecipes = RecipeModel.shared.favoriteRecipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Setup Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteCell
        if favoriteRecipes.count > 0 {
            let recipe = favoriteRecipes[indexPath.row]
            cell.favoriteImage.kf.setImage(with: URL(string:"https://spoonacular.com/recipeImages/\(recipe.id)-240x150.jpg"))
            cell.favoriteLabel.text = recipe.title
        }
        return cell
    }
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if let InfoVC = segue.destination as? RecipeInfoViewController {
             let row = tableView.indexPathForSelectedRow!.row
             InfoVC.recipe = favoriteRecipes[row]
         }
     }

}
