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
    // 账户路径 ， 用来获取沙盒位置
    static let userAccountPath =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
    
    // 从沙盒中读取
    init() {
        let viewModel = readBySandBox()
        if viewModel != nil {
            self.viewModel = viewModel!
        }
    }
    
    // 登录：complateHandler 结果返回成功，failedHandler 结果返回失败
    func login(username: String,
               password: String,
               // 完成的处理回调
               complateHandler: @escaping ((String?) -> Void),
               // 失败的处理回调
               failedHandler: @escaping ((Error) -> Void)) {
        // key:value 字典。拼接参数。
        let params = [
            "phoneNumber": username,
            "password": password,
             "nickname": "",
        ]

        // 用Network网络请求，构造http请求体。传参。
        // 调用post请求。“http...”-后端登录接口的api。
        Network.shared.post(urlString: "http://localhost:8080/login",
                            // 参数：参数的集合
                            params: params,
                            // 完成的处理回调（在此处理 请求完服务端后返回的数据）
                            complateHandler: {
                                // 把第0个参数，强转为字典类型key,value
                                let dataDict = $0 as! Dictionary<String, Any>
                                // 例如此处是取key为"error"的
                                if dataDict["error"] != nil {
                                    // 如果存在异常返回原因 String类型。调用系统的...
                                    complateHandler((dataDict["reason"] as! String))
                                } else {
                                    // 如果合法没有error，直接获取用户所输入的
                                    self.viewModel.phoneNumber = username
                                    // 服务端返回的token
                                    self.viewModel.token = (dataDict["token"] as! String)
                                    // 返回的“Token”里有所有信息
                                    self.viewModel.uid = (dataDict["userId"] as! Int)
                                    self.saveToSandBox()
                                    // 结果返回成功
                                    complateHandler(nil)
                                }
        }) {
            print($0!)
            failedHandler($0!)
        }
    }
    
    func details() {
        
    }
    
    // 注册，结果返回成功/失败
    func register(username: String,
                  password: String,
                  // 完成的处理回调
                  complateHandler: @escaping ((String?) -> Void),
                  // 失败的处理回调
                  failedHandler: @escaping ((Error) -> Void)) {
        // key:value 字典。拼接参数。
        let params = [
            "phoneNumber": username,
            "password": password,
            "nickname": "",
        ]
        
        // 用Network网络请求，构造http请求体
        // 调用post请求。“http...”-后端注册接口的api。
        Network.shared.post(urlString: "http://localhost:8080/register",
                            // 参数：参数的集合
                            params: params,
                            // 完成的处理回调（在此处理 请求完服务端后返回的数据）
                            complateHandler: { (dataArr) in
                                // 注册成功后 直接登录
                                self.login(username: username,
                                           password: password,
                                           complateHandler: {
                                            complateHandler($0)
                                }, failedHandler: {
                                    failedHandler($0)
                                })
        }) {
            failedHandler($0!)
        }
    }
    
    // 退出登录，发送请求给服务器 清除Token，客户端再清除Token
    func logout(complateHandler: @escaping (() -> Void)) {
        Network.shared.get(urlString: "http://localhost:8080/api/user/logout",
                           params: [:],
                           complateHandler: { (data) in
                            // token: nil 清除token
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
    /// 保存到沙盒中
    func saveToSandBox() {
        // 编码器。将数据转为二进制流 才可存入沙盒
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
