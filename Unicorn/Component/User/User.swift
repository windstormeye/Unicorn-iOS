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
    
    init() {
        let viewModel = readBySandBox()
        if viewModel != nil {
            self.viewModel = viewModel!
        }
    }
    
    func login(username: String,
               password: String,
               complateHandler: @escaping (() -> Void),
               failedHandler: @escaping ((Error) -> Void)) {
        let params = [
            "phoneNumber": username,
            "password": password,
            "nickname": "",
        ]
        Network.shared.post(urlString: "http://localhost:8080/login",
                            params: params,
                            complateHandler: {
                                let dataDict = $0 as! Dictionary<String, Any>
                                self.viewModel.phoneNumber = username
                                self.viewModel.token = (dataDict["token"] as! String)
                                self.viewModel.uid = (dataDict["userId"] as! Int)
                                
            self.saveToSandBox()
            
            complateHandler()
        }) {
            print($0!)
            failedHandler($0!)
        }
    }
    
    func details() {
        
    }
    
    func register(username: String,
                  password: String,
                  complateHandler: @escaping (() -> Void),
                  failedHandler: @escaping ((Error) -> Void)) {
        let params = [
            "phoneNumber": username,
            "password": password,
            "nickname": "",
        ]
        Network.shared.post(urlString: "http://localhost:8080/register",
                            params: params,
                            complateHandler: { (dataArr) in
                                self.login(username: username,
                                           password: password,
                                           complateHandler: {
                                            complateHandler()
                                }, failedHandler: {
                                    failedHandler($0)
                                })
        }) {
            failedHandler($0!)
        }
    }
    
    func logout(complateHandler: @escaping (() -> Void)) {
        Network.shared.get(urlString: "http://localhost:8080/api/user/logout",
                           params: [:],
                           complateHandler: { (data) in
                            self.viewModel = ViewModel(uid: nil, token: nil, nickname: nil, phoneNumber: nil, password: nil)
                            self.saveToSandBox()
                            complateHandler()
        }) {
            print($0!)
        }
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
    /// 保持到沙盒中
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
    
    /// 从沙盒中读取
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
