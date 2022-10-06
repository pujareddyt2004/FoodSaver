//
//  ViewController.swift
//  FoodSaver
//
//  Created by Puja Reddy on 10/6/22.
//  Copyright © 2022 Puja Reddy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //let apiKey = "6c2f7b5d1c7d41f9a2c0b5c9ca99f50f"
        
        //let url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=6c2f7b5d1c7d41f9a2c0b5c9ca99f50f"
        
        let url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=6c2f7b5d1c7d41f9a2c0b5c9ca99f50f&ingredients=apples#"
        
        print("HERE")
        getData(from: url)
    }
    
    private func getData(from url: String){
        
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            
            guard let data = data, error == nil else{
                print("Something went wrong")
                return
            }
            
            print(data)
            //have data
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else{
                return
            }
            
            /*print(json.title)
            print(json.image)
            print(json.missedIngredients.aisle)*/
            print("HERE")
            print(json)
        })
        
        task.resume()
    }
    

}


struct Response: Codable {
    let id: Int
    let title: String
    let image: String
    let imageType: String
    let usedIngredientCount: Int
    let missedIngredientCount: Int
    let missedIngredients: MyMissedIngrediants
    let usedIngredients: MyUsedIngredients
    let likes: Int
}

struct MyMissedIngrediants: Codable {
    let id: Int
    let amount: Int
    let unit: String
    let unitLong: String
    let unitShort: String
    let aisle: String
    let name: String
    let original: String
    let originalName: String
    let meta: String            //type []?
    let image: String
}

struct MyUsedIngredients: Codable {
    let id: Int
    let amount: Int
    let unit: String
    let unitLong: String
    let unitShort: String
    let aisle: String
    let name: String
    let original: String
    let originalName: String
    let meta: String
    let image: String
}

