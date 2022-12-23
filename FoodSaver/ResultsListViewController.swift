//
//  ResultsListViewController.swift
//  FoodSaver
//
//  Created by Puja Reddy on 10/25/22.
//  Copyright © 2022 Puja Reddy. All rights reserved.
//

import UIKit

class ResultsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UINavigationItem!
    
    var ingrediant = "placeholder"
    var myid = 0
    
    var recipe = [Response]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        downloadJSON {
            self.tableView.reloadData()
            print("success")
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let one = recipe[indexPath.row]
            
                //recipe title name
                cell.textLabel?.text = one.title.capitalized
            
                //recipe image
                let imageUrl = URL(string: one.image)!
                let imageData = try! Data(contentsOf: imageUrl)
                let myimage = UIImage(data: imageData)
                cell.imageView?.image = myimage
        
                //adding subtext - tot ingrediant count
                let totIngrediants = one.missedIngredientCount + one.usedIngredientCount
                let intString = String(totIngrediants)
                
                cell.detailTextLabel?.text = "Total Number Ingrediants : " + intString
        
                cell.textLabel?.numberOfLines = 2
                
                return cell
    }
    
    var idToSend : Int = 0
    var recipeNameToSend : String = ""
    
    // performs segue when individual recipe selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let one = recipe[indexPath.row]
        idToSend = one.id
        recipeNameToSend = one.title
    
        self.performSegue(withIdentifier: "infoView", sender: nil)
    }
    
    // pass data to next segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MoreInfoViewController {
            destination.myid = idToSend
            destination.myrecipe = recipeNameToSend
        }
    }
    


    // get api data to show related recipes
    func downloadJSON(completed: @escaping () -> ()) {
        let url = URL(string: "https://api.spoonacular.com/recipes/findByIngredients?apiKey=6c2f7b5d1c7d41f9a2c0b5c9ca99f50f&ingredients=" + ingrediant + "&number=15" + "#")!
        
        URLSession.shared.dataTask(with: url) {data, response, err in
            
            if err == nil {
                do {
                    self.recipe = try JSONDecoder().decode([Response].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                catch {
                    print("error fetching data from api")
                }
            }
        }.resume()
        
    }
    
    
    

}
