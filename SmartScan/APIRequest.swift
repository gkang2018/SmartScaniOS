//
//  APIRequest.swift
//  SmartScan
//
//  Created by Joshua Diamond on 2/8/20.
//  Copyright © 2020 Gagandeep Kang. All rights reserved.
//

import Foundation


class APIRequest {
    var url: String;
    var barcode: String;
    var jsonData: String;
    init(data:String) {
        self.url = "zachbodi.pythonanywhere.com/";
        self.barcode = data;
        self.jsonData = ""
    }
    
    func makeGetRequest() -> String{
        let session = URLSession.shared
        let url = URL(string: self.url + barcode)!
        
        let task = session.dataTask(with: url) { data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }

            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                self.jsonData = json as! String
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
        return self.jsonData
    }

}
