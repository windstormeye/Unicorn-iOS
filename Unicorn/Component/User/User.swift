//
//  User.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/7.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import Foundation

class User {
    static let shared = User()
    var viewModel = ViewModel()
    static let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    func login() {
        
//        Network.shared.get(urlString: "http://localhost:8080/api/user", complateHandler: { (dict) in
//            print(dict)
//        }) { (error) in
//
//        }
    }
    
    func details() {
        
    }
    
    func register() {
        let params = [
            "phoneNumber": "18811758981",
            "password": "woaiwoziji123",
            "nickname": "pjhubs",
        ]
        Network.shared.post(urlString: "http://localhost:8080/register", params: params, complateHandler: { (dataArr) in
            print(dataArr)
        }) {
            print($0)
        }
    }
    
    func logout() {
        
    }
    
    func update() {
        
    }
}

extension User {
    struct ViewModel: Codable {
        var uid: Int?
        var token: String?
        var nickname: String?
        var phoneNumber: String?
        var password: String?
    }
}

extension User {
    func saveToSandBox() {
        let encoder = JSONEncoder()
        if let BeerData = try? encoder.encode(self.viewModel) {
            let url = URL.init(fileURLWithPath: User.userAccountPath).appendingPathComponent("userData.data")
            do {
                try BeerData.write(to: url)
                print("完成了对数据的二进制化归档")
            } catch {
                print("saveToSandBox \(error.localizedDescription)")
                assert(true, "saveToSandBox \(error.localizedDescription)")
            }
        }
    }
    
    
    func readBySandBox() -> ViewModel? {
        let url = URL.init(fileURLWithPath: User.userAccountPath).appendingPathComponent("userData.data")
        do {
            let data = try FileHandle.init(forReadingFrom: url)
            do {
                return try JSONDecoder().decode(ViewModel.self, from: data.readDataToEndOfFile())
            } catch {
                assert(true, "readBySandBox JSONDecoder \(error.localizedDescription)")
            }
        } catch {
            assert(true, "readBySandBox \(error.localizedDescription)")
        }
        return nil
    }
}
