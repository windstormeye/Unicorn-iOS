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

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let home = UNContentViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = home
        window?.makeKeyAndVisible()
        return true
    }
}

