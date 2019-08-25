//
//  File.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/7.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

// 网络请求封装的类

class Network {
    // 单例
    static let shared = Network()
    
    // complateHandler 证明结果返回成功，failedHandler 返回失败
    func get( urlString: String,
             params: [String: String],
             complateHandler: @escaping ((Any) -> Void),
             failedHandler: @escaping ((Error?) -> Void)) {
        // 临时url 例如："http://localhost:8080/api/sticker?bookId=1"
        var tempUrlString = urlString + "?"
        for d in params {
            let dString = d.key + "=" + d.value + "&"
            tempUrlString += dString
        }
        // 移除
        tempUrlString.removeLast()
        
        
        let url = URL(string: tempUrlString)!
        
        // url请求，把token信息带上，发送请求
        var request = URLRequest(url: url)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if User.shared.viewModel.token != nil {
            request.setValue("Bearer " + User.shared.viewModel.token!, forHTTPHeaderField: "Authorization")
        }
//        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // 发送http请求，拿到数据
        let task = session.dataTask(with: request) { (responseData, urlResponseData, error) in
//            guard error != nil else { failedHandler(error) }
            // 加上 do-catch
            // responseData 响应数据
            if responseData?.count == 0 {
                // 证明结果返回成功
                complateHandler(0)
            } else {
                if responseData != nil {
                    let resDict = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if resDict != nil {
                        complateHandler(resDict!)
                    }
                }
            }
        }
        task.resume()
    }
    
    // post “更新” ... 构造 http请求体 
    func post(urlString: String,
              params: [String: Any],
              complateHandler: @escaping ((Any) -> Void),
              failedHandler: @escaping ((Error?) -> Void)) {
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
            //            guard error != nil else { failedHandler(error) }
            
            // 加上 do-catch
            if responseData?.count != 0 {
                if responseData != nil {
                    let resDict = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                    if resDict != nil {
                        complateHandler(resDict!)
                    }
                }
            } else {
                complateHandler("")
            }
        }
        task.resume()
    }
    
}
