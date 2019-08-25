//
//  UNBottomFontsTableViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/4.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 点击下栏按钮后弹出的选项：是列表视图 UITableViewController
class UNBottomFontsTableViewController: UITableViewController {
    // 字体数据源（字符串数组）（字符串数据源 传进来）
    var fonts = [String]() {didSet{ tableView.reloadData() }}
    var cellSelected: ((Int) -> Void)?
    
    // 加载完视图
    override func viewDidLoad() {
        // override重载，要调用父视图的方法（super）
        super.viewDidLoad()
        // 要将cell注册进视图里，给cell标识符
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    // 设置Section里内容的个数
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    // 每一个cell里的Item。定义内容。
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 要将cell注册进视图里，给cell标识符
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "这是字体"
        // 赋值字体。（字体数据源数组）字体 - 根据cell下标索引取fonts数据源里的数据
        cell.textLabel?.font = UIFont(name: fonts[indexPath.row], size: 20)
        return cell
    }

    // (点击字体的响应事件)
    //  didSelectRowAt 已经选择了的Row，通过索引来判断
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
    
}
