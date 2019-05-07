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
    
    func get(urlString: String,
             complateHandler: @escaping ((Array<Any>) -> Void),
             failedHanler: @escaping ((Error?) -> Void)) {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request) { (responseData, urlResponseData, error) in
//            guard error != nil else { failedHanler(error) }

            // 加上 do-catch
            let resDict = try! JSONSerialization.jsonObject(with: responseData!, options: .allowFragments) as! Array<Any>
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
