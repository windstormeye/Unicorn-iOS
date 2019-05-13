//
//  AppDelegate.swift
//  Unicorn
//
//  Created by YiYi on 2019/3/24.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let home = UNNoteViewController()
        let nav = UINavigationController(rootViewController: home)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

