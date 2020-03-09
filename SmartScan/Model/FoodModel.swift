//
//  FoodModel.swift
//  SmartScan
//
//  Created by Gagandeep Kang on 2/11/20.
//  Copyright © 2020 Gagandeep Kang. All rights reserved.
//

import Foundation


struct FoodData: Codable {
    let ingredients: [String]
    let light: String
    let brand: String
    let product: String
    let tested_ingredients: String
    
}
