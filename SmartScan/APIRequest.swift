//
//  APIRequest.swift
//  SmartScan
//
//  Created by Joshua Diamond on 2/8/20.
//  Copyright © 2020 Gagandeep Kang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIRequest {
    var url: String;
    var barcode: String;
    var foodDataModel = FoodDataModel()
    init(data:String) {
        self.url = "http://zachbodi.pythonanywhere.com/";
        self.barcode = data;
    }
    
    func makeGetRequest() {
        self.url = self.url + self.barcode
        AF.request(url, method: .get).validate().responseData { response in
            guard let data = response.data else {return } // figure this thing out
            let json = try? JSON(data:data)
            self.parseJSON(json: json!)
        }

}
    
    func parseJSON(json: JSON) {
        if json["ingredients"].arrayValue == [] {
            foodDataModel.isEmpty = true
            return
        }
        // iterate through the ingredients list and add it to our food datamodel
        for ingredient in json["ingredients"] {
            foodDataModel.ingredients.append(ingredient.1.stringValue)
        }
        foodDataModel.testedIngredients = json["tested_ingredients"].stringValue
        foodDataModel.product = json["product"].stringValue
        foodDataModel.foodBrand = json["brand"].stringValue
        foodDataModel.light = json["light"].stringValue
            
    }
}
