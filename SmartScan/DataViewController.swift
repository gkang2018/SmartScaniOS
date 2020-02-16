//
//  DataViewController.swift
//  SmartScan
//
//  Created by Joshua Diamond on 2/8/20.
//  Copyright © 2020 Gagandeep Kang. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {
    
    var testedIngredients: String = ""
    var product: String = ""
    var brand: String = ""
    var ingredients: [String] = []
    var light: String =  ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    @IBOutlet weak var lightImage: UIImageView!
    
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var productLabel: UILabel!
    
    @IBOutlet weak var brandLabel: UILabel!
    func updateUI() {
        // first update the image
        
        var imageExtension = ""
        
        switch self.light {
        
        case "untested":
            imageExtension = "green.png"
        case "red":
            imageExtension = "red.png"
        case "yellow":
            imageExtension = "yellow.png"
        case "green":
            imageExtension = "green.png"
        default:
            imageExtension = "yellow.png"
        }
        
        self.lightImage.image = UIImage(named: imageExtension)
        
        self.productLabel.text = self.product
        
        self.brandLabel.text = self.brand
        
        let stringRepresentationIngredients = ingredients.joined(separator: ",")
        
        textView.text = stringRepresentationIngredients
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
