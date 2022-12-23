//
//  MoreInfoViewController.swift
//  FoodSaver
//
//  Created by Puja Reddy on 11/26/22.
//  Copyright © 2022 Puja Reddy. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    var myid = 0
    var myrecipe = "placeholder"
    
    //data from api
    var imageUrl = ""
    var timeString = ""
    var summary = ""
    var attrSummary : NSAttributedString?
    var ingredientListString = ""
    var instructionsString = ""
    var attrInstr : NSAttributedString?
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var recipeSummaryText: UILabel!
    
    @IBOutlet weak var totalTimeText: UILabel!
    
    @IBOutlet weak var servingText: UILabel!
    
    @IBOutlet weak var healthScoreText: UILabel!
    
    @IBOutlet weak var ingredientListText: UILabel!
    
    @IBOutlet weak var instructionsText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = myrecipe
        
        print(myid)
        
        let idString = String(myid)
        let url = "https://api.spoonacular.com/recipes/" + idString + "/information?includeNutrition=false&apiKey=6c2f7b5d1c7d41f9a2c0b5c9ca99f50f"
        getData(from: url)
    }
    
    
    // get api data to show more info about selected recipe
    private func getData(from url: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            // have data - convert from bytes to object struct
            var result: Info?
            do {
                result = try JSONDecoder().decode(Info.self, from: data)
            }
            catch {
                print("failed to convers \(error.localizedDescription)")
                print(error)
            }
            
            guard let json = result else {
                return
            }
            
            //health score
            //self.healthScore = json.healthScore
            //self.scoreString = String(self.healthScore)
            //self.changeScore()
            
            // likes
            self.healthScoreText.text = String(json.aggregateLikes)
            
            // time
            self.timeString = String(json.readyInMinutes)
            self.timeString = self.timeString + " min"
            self.totalTimeText.text = self.timeString
            
            //serving
            self.servingText.text = String(json.servings)
            
            //summary
            self.summary = json.summary
            self.attrSummary = try! NSAttributedString(
            data: self.summary.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
            self.changeSummary()
            
            //image
            self.imageUrl = json.image
            self.changeImg()
            
            //ingredients
            let allIngredientInfo = json.extendedIngredients
            print("CHECK HERE")
            for ingredient in allIngredientInfo {
                print(ingredient.original)
                self.ingredientListString = self.ingredientListString + " - " + ingredient.original + "\n"
            }
            print(self.ingredientListString)
            self.changeIngredients()
            
            //instructions
            self.instructionsString = json.instructions
            self.attrInstr = try! NSAttributedString(
            data: self.instructionsString.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
                     .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
            //let attrInstr = [ NSAttributedString.Key.font: UIFont(name: <#String#>, size: 20.0)! ]
            self.changeInstructions()
            
        })
        
        task.resume()
    }
    
    
    func changeImg() -> () {
        print(imageUrl)
        let convertedImgURL = URL(string: imageUrl)!
        let imageData = try! Data(contentsOf: convertedImgURL)
        let myimage = UIImage(data: imageData)
        recipeImage.image = myimage
    }
    
    func changeSummary() -> () {
        self.recipeSummaryText.attributedText = self.attrSummary
    }
    
    func changeIngredients() -> () {
        self.ingredientListText.text = self.ingredientListString
    }
    
    func changeInstructions() -> () {
        self.instructionsText.attributedText = self.attrInstr
    }
    
    /*
    func changeTime() -> () {
        self.totalTimeText.text = self.timeString
    }
    func changeServing() -> () {
        self.servingText.text = self.servingString
    }
    func changeScore() -> () {
        self.healthScoreText.text = self.scoreString
    }
    func changeLikes() -> () {
         self.healthScoreText.text = self.likesString
    }
    */
    
}
