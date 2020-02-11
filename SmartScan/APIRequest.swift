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

protocol APIManagerDelegate {
    func didUpdateFood(_apiRequest: APIRequest, foodData: FoodDataModel)
    func didFail(error: Error)
}


struct APIRequest {
    let url = "http://zachbodi.pythonanywhere.com/";
    var delegate: APIManagerDelegate?
    
    func getFoodData(barcode: String) {
        let urlString = self.url + barcode
        makeGetRequest(with: urlString)
    }
    
    
    func makeGetRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFail(error: error!)
                    return
                }
                if let safeData = data {
                    if let food = self.parseJSON(safeData) {
                        self.delegate?.didUpdateFood(_apiRequest: self, foodData: food)
                    }
                }
            }
            task.resume()
        }
}

    func parseJSON(_ foodData: Data) -> FoodDataModel? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(FoodData.self, from: foodData)
            let ingredients = decodedData.ingredients
            let light = decodedData.light
            let foodBrand = decodedData.foodBrand
            let product = decodedData.product
            let testedIngredients = decodedData.testedIngredients
            
            let foodResults = FoodDataModel(ingredients: ingredients, light: light, foodBrand: foodBrand, product: product, testedIngredients: testedIngredients)
            return foodResults
        }
        catch {
            delegate?.didFail(error: error)
            return nil
        }
        


    }
}
