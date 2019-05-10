//
//  File.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/7.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

class Network {
    static let shared = Network()
    
    func get( urlString: String,
             params: [String: String],
             complateHandler: @escaping ((Any) -> Void),
             failedHanler: @escaping ((Error?) -> Void)) {
        var tempUrlString = urlString + "?"
        for d in params {
            let dString = d.key + "=" + d.value + "&"
            tempUrlString += dString
        }
        
        tempUrlString.removeLast()
        
        
        let url = URL(string: tempUrlString)!
        let request = URLRequest(url: url)

        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (responseData, urlResponseData, error) in
//            guard error != nil else { failedHanler(error) }

            // 加上 do-catch
            let resDict = try! JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            complateHandler(resDict)
        }
        task.resume()
    }
    
    func post(urlString: String,
              params: [String: Any],
              complateHandler: @escaping ((Any) -> Void),
              failedHanler: @escaping ((Error?) -> Void)) {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if User.shared.viewModel.token != nil {
            request.setValue("Bearer " + User.shared.viewModel.token!, forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (responseData, urlResponseData, error) in
            //            guard error != nil else { failedHanler(error) }
            
            // 加上 do-catch
            let resDict = try! JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            complateHandler(resDict)
        }
        task.resume()
    }
    
}
