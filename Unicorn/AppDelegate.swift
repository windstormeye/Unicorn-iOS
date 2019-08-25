//
//  AppDelegate.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/24.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // 规定主类必须要遵从协议 `UIApplicationDelegate`，该 `UIApplicationDelegate` 依赖 `UIResponder`。
    // UIApplicationDelegate 协议用来管理应用状态。 UIResponder 协议用来响应用户点击（UI事件）。

    var window: UIWindow?

    // 加载完成 伴随选项，
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 对象 实例化  手帐本-首页
        let home = UNNoteViewController()
        //  Navigation Controller导航视图控制器（用来控制页面，栈的形式，先进后出）
        let nav = UINavigationController(rootViewController: home)
        
        // 创建UIWindow，设置界限属性 主屏幕宽高 坐标
        window = UIWindow(frame: UIScreen.main.bounds)
        // 设置根视图控制器
        window?.rootViewController = nav
        // 成为 keyWindow 并显示
        window?.makeKeyAndVisible()
        return true
    }
}

