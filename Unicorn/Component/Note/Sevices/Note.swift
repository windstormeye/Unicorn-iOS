//
//  NoteSevice.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 提供增删改查服务（“M”）

class Note {
    
    // 单例（此类就这一个对象）
    static let shared = Note()
    
    // @escaping 逃逸闭包。
    func create(viewModel: ViewModel,
                // “完成”闭包 证明结果返回成功
                compalteHandler: @escaping (() -> Void),
                // “失败”闭包 证明结果返回失败
                failedHandler: @escaping ((Error) -> Void)) {
        // 【字典】【key:value】赋值，API需要，coverColor是拼接好的颜色字符串
        let params = [
            "userId": User.shared.viewModel.uid!,
            "coverTitle": viewModel.coverTitle,
            "coverColor": viewModel.coverColor
            ] as [String : Any]  // 强转类型
        Network.shared.post(urlString: "http://localhost:8080/api/note", params: params, complateHandler: { _ in
            // 证明结果返回成功
            compalteHandler()
        }) {
            // 证明结果返回失败
            failedHandler($0!)
        }
    }
    
    // 获取所有手帐本 ， escaping异步方法
    func get(compalteHandler: @escaping (([[String: Any]]) -> Void),
             failedHandler: @escaping ((Error) -> Void)) {
        // API需要，下面的url接口需要
        let params = [
            "userId": String(User.shared.viewModel.uid!),
            ]
        Network.shared.get(urlString: "http://localhost:8080/api/note", params: params, complateHandler: {
            print($0)
            // 证明结果返回成功
            compalteHandler($0 as! Array<Dictionary<String, Any>>)
        }) {
            // 证明结果返回失败
            failedHandler($0!)
        }
    }
    
    func delete(bookId: String,
                compalteHandler: @escaping (() -> Void),
                failedHandler: @escaping ((Error) -> Void)) {
        let params = [
            "bookId": bookId,
        ]
        
        // 调用get方法。
        Network.shared.get(urlString: "http://localhost:8080/api/note/delete", params: params, complateHandler: {
            print($0)
            compalteHandler()
        }) {
            failedHandler($0!)
        }
    }
}

extension Note {
    // 视图模型结构体
    struct ViewModel {
        // 手帐本 名称
        var coverTitle: String
        // 手帐本 颜色
        var coverColor: String
    }
}
