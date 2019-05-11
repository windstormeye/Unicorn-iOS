//
//  StickerService.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class Sticker {
    static let shared = Sticker()
    
    func create(viewModel: ViewModel,
                complateHandler: @escaping (() -> Void),
                failedHanler: @escaping ((Error) -> Void)) {
        var params = [
            "x": viewModel.x,
            "y": viewModel.y,
            "w": viewModel.w,
            "h": viewModel.h,
            "rotate": viewModel.rotate,
            "type": viewModel.type,
            ] as [String : Any]
        
        if viewModel.defaultIndex != nil {
            params["defaultIndex"] = viewModel.defaultIndex!
        }
        
        if viewModel.data != nil {
            params["data"] = viewModel.data!
        }
        
        if viewModel.bookId != nil {
            params["bookId"] = viewModel.bookId!
        }
        
        Network.shared.post(urlString: "http://localhost:8080/api/sticker", params: params, complateHandler: {
            print($0)
            complateHandler()
        }) {
            failedHanler($0!)
        }
    }
    
    func get(bookId: Int,
             complateHandler: @escaping (([[String: Any]]) -> Void),
             failedHanler: @escaping ((Error) -> Void)) {
        Network.shared.get(urlString: "http://localhost:8080/api/sticker", params: ["bookId": String(bookId)], complateHandler: {
            complateHandler($0 as! [[String : Any]])
        }) {
            print($0!)
        }
    }
    
    func update(viewModel: ViewModel,
                complateHandler: @escaping (() -> Void),
                failedHanler: @escaping ((Error) -> Void)) {
        var params = [
            "x": viewModel.x,
            "y": viewModel.y,
            "w": viewModel.w,
            "h": viewModel.h,
            "rotate": viewModel.rotate,
            "bookId": viewModel.bookId!,
            "type": viewModel.type,
            "id": viewModel.id!
            ] as [String : Any]
        
        if viewModel.defaultIndex != nil {
            params["defaultIndex"] = viewModel.defaultIndex!
        }
        
        if viewModel.data != nil {
            params["data"] = viewModel.data!
        }

        Network.shared.post(urlString: "http://localhost:8080/api/sticker/update", params: params, complateHandler: {
            print($0)
            complateHandler()
        }) {
            failedHanler($0!)
        }
    }
}

extension Sticker {
    struct ViewModel: Codable {
        var id: Int?
        var x: CGFloat
        var y: CGFloat
        var w: CGFloat
        var h: CGFloat
        var rotate: CGFloat
        var type: Int
        var data: Data?
        var bookId: Int?
        var defaultIndex: Int?
    }
}
