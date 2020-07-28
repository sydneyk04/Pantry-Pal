//
//  SearchModel.swift
//  Pantry Pal
//
//  Created by Sydney Nguyen on 4/20/20.
//  Copyright © 2020 Sydney Nguyen. All rights reserved.
//

import Foundation

class SearchModel {
    
    static let shared = SearchModel()
    private let API_KEY = "211b3e5310f34805ab1bb3d4157b2027"
    private let BASE_URL = "https://api.spoonacular.com"
    private let RECIPE_COUNT = 20
    public var query = "random"
    
    public var recipes : [Recipe] = []
    
    func getRecipes(onSuccess: @escaping ([Recipe]) -> Void) {
        
        if let url = URL(string: "\(BASE_URL)/recipes/search?query=\(query)&apiKey=\(API_KEY)&number=\(RECIPE_COUNT)"){
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Client-ID \(API_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest, completionHandler:
                {(data,response,error) in
                    if let data = data {
                        do{
                            let recipes = try JSONDecoder().decode(Initial.self, from: data)
                            onSuccess(recipes.results)
                        }
                        catch{
                            print(error)
                            exit(1)
                        }
                    }
                
                }).resume()
        }
        
    }
}
