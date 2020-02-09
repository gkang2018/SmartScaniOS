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
    let foodDataModel = FoodDataModel
    init(data:String) {
        self.url = "http://zachbodi.pythonanywhere.com/";
        self.barcode = data;
    }
    
    func makeGetRequest() {
        self.url = self.url + self.barcode
        AF.request(url, method: .get).validate().responseData { response in
            print(response.result)
            guard let data = response.data else {return } // figure this thing out
            let json = try? JSON(data:data)
            print(json)
        }

}
    
    func parseJSON(json: JSON) {
        
    }

}
