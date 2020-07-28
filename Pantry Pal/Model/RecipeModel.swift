//
//  RecipeInfo.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/28/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import Foundation
import Firebase

class RecipeModel {
    static let shared = RecipeModel()
    
    public var favoriteRecipes: [Recipe] = []
    private var favoriteIds:[Int] = []

       
}
