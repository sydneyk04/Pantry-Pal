//
//  RecipeListViewController.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/23/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import UIKit
import Kingfisher


class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
  
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadRecipes()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    // API call to get recipes 
    func loadRecipes() {
        SearchModel.shared.getRecipes(onSuccess: {(recipes) in
            DispatchQueue.main.async{
                //print(recipes.count)
                SearchModel.shared.recipes = recipes
                self.tableView.reloadData()
            }
        })
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SearchModel.shared.recipes.count
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeViewCell
        if SearchModel.shared.recipes.count > 0 {
            let recipe = SearchModel.shared.recipes[indexPath.row]
            cell.recipeImageView.kf.setImage(with: URL(string:"https://spoonacular.com/recipeImages/\(recipe.id)-240x150.jpg"))
            cell.RecipeTitleLabel.text = recipe.title
        }
        return cell
         
     }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let InfoVC = segue.destination as? RecipeInfoViewController {
            let row = tableView.indexPathForSelectedRow!.row
            InfoVC.recipe = SearchModel.shared.recipes[row]
        }
    }
}

