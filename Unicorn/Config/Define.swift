//
//  Define.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit


let screenWidth = UIScreen.main.bounds.size.width
let screentHeight = UIScreen.main.bounds.size.height
// 底部安全距离
let bottomSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0

//顶部的安全距离
let topSafeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0.0

//状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.height;

//导航栏高度
let navigationHeight = 44 + topSafeAreaHeight

