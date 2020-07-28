//
//  Recipe.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/20/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import Foundation

struct Initial: Codable {
    let results: [Recipe]
}

struct Recipe : Codable {
    let id: Int
    let image: String
    let servings: Int
    let sourceUrl: String
    let readyInMinutes: Int
    let title: String
}

