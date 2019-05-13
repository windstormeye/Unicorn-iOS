//
//  NoteSevice.swift
//  Unicorn
//
//  Created by YiYi on 2019/5/10.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

class Note {
    static let shared = Note()
    
    func create(viewModel: ViewModel,
                compalteHandler: @escaping (() -> Void),
                failedHandler: @escaping ((Error) -> Void)) {
        let params = [
            "userId": User.shared.viewModel.uid!,
            "coverTitle": viewModel.coverTitle,
            "coverColor": viewModel.coverColor
            ] as [String : Any]
        Network.shared.post(urlString: "http://localhost:8080/api/note", params: params, complateHandler: {
            print($0)
            compalteHandler()
        }) {
            failedHandler($0!)
        }
    }
    
    func get(compalteHandler: @escaping (([[String: Any]]) -> Void),
             failedHandler: @escaping ((Error) -> Void)) {
        let params = [
            "userId": String(User.shared.viewModel.uid!),
            ]
        
        Network.shared.get(urlString: "http://localhost:8080/api/note", params: params, complateHandler: {
            print($0)
            compalteHandler($0 as! Array<Dictionary<String, Any>>)
        }) {
            failedHandler($0!)
        }
    }
}

extension Note {
    struct ViewModel {
        var coverTitle: String
        var coverColor: String
    }
}
