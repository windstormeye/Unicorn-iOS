//
//  UNNoteViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNNoteViewController: UIViewController {

    // coverId 手帐封面id（用数组存了封面了id）
    private var coverIds = [Int]()
    // 封面-集合视图
    private var collectionView: UNLineCollectionView?
    // 布尔值（是否选中删除按钮）
    private var deleteSelected = false
    private var deleteBarItemButton = UIBarButtonItem()
    // 页面加载完了
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // 初始化视图
    private func initView() {
        // 页面的标题
        navigationItem.title = "Unicorn 手帐"
        if User.shared.viewModel.nickname != nil {
            navigationItem.title = User.shared.viewModel.nickname!
        }
        view.backgroundColor = .white
        // 顶部标题-颜色 文字什么的颜色
        navigationController?.navigationBar.tintColor = .black
        
        // deleteNote 方法 【删除】手帐本
        deleteBarItemButton = UIBarButtonItem(title: "删除", style: .plain, target: self, action: #selector(deleteNote))
        
        // 顶部 右侧bar按钮（使用系统图标，target谁响应方法，动作：addNote方法）
        // rightBarButtonItems 按钮数组。-- [删除，添加] -- 【添加】addNote方法 新建手帐本
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote)), deleteBarItemButton]
        // 顶部 左侧 【退出登录】（使用系统图标）-- logout方法
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(logout))
        
        // 集合视图 布局（所有手帐本）
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = view.width * 0.4
        // 数量（一行两个）
        let itemCount = CGFloat(2)
        // 内部间距
        let innerW = (view.width - itemCount * itemW) / itemCount
        // 每一个封面的大小，长是宽的1.7倍
        collectionViewLayout.itemSize = CGSize(width: itemW, height: itemW * 1.7)
        // 最小行间距
        collectionViewLayout.minimumLineSpacing = innerW
        // 最小项艰巨
        collectionViewLayout.minimumInteritemSpacing = 10
        // 滚动方向 = 垂直
        collectionViewLayout.scrollDirection = .vertical
        // 距离四周的距离
        collectionViewLayout.sectionInset = UIEdgeInsets(top: innerW / 2, left: innerW / 2, bottom: 20, right: innerW / 2)
        
        // 线性集合视图 设置xy宽高（手帐本）
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: navigationHeight, width: view.width, height: view.height - navigationHeight - bottomSafeAreaHeight), collectionViewLayout: collectionViewLayout)
        
        self.collectionView = collectionView
        collectionView.backgroundColor = .clear
        // lineType 线性集合视图 cover封面类型
        collectionView.lineType = .cover
        view.addSubview(collectionView)
        
        // ----- 手帐本的点击事件。-----
        // 选择一个cell，跳到所选择的手帐页面。点击后返回的是手帐本的cellIndex
        collectionView.cellSelected = { cellIndex in
            // 用deleteSelected属性判断是否点击了“删除”
            if self.deleteSelected {
                // 取到手帐本数组中该手帐本的index，赋值。
                // 进入手帐本界面，就会给所有手帐的coverIds赋值。具体的在getAllNote方法中。
                let bookId = self.coverIds[cellIndex]
                // 用被赋值的bookId
                Note.shared.delete(bookId: String(bookId), compalteHandler: {
                    // 调用getAllNote
                    self.getAllNote()
                }, failedHandler: {
                    // 失败，仅显示在控制台终端
                    print($0.localizedDescription)
                })
            } else { // 没有点击删除，则正常进入
                let vc = UNContentViewController()
                // 数据源，coverId封面id取出给这里的bookId
                vc.bookId = self.coverIds[cellIndex]
                // 导航控制器 视图控制器
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // 视图出现
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 若token为空
        if User.shared.viewModel.token == nil {
            // 弹出登陆界面（bundle“沙盒”，nil默认当前文件夹）
            let sb = UIStoryboard(name: "UNUserLoginViewController", bundle: nil)
            // 实例化ViewController
            let vc = sb.instantiateViewController(withIdentifier: "UNUserLoginViewController")
            // 界面从底部弹出（是否用动画true，弹出结束nil）
            present(vc, animated: true, completion: nil)
            return
        }
        
        getAllNote()
    }
    
    func getAllNote() {
        // 获取所有的手帐本 - 调用get方法
        Note.shared.get(compalteHandler: {
            // 用数组存储标题、背景颜色
            var titles = [String]()
            var colors = [UIColor]()
            
            // 刷新时，要移除之前的coverIds数据（类比1231234）。下面重新赋值
            self.coverIds.removeAll()
            
            // 从服务端获取数据 - 遍历数据
            // d：返回数组里的每一个实体
            for d: Dictionary in $0 {
                // 添加 封面名称 为"coverTitle"。取实体d中的coverTitle，强转为String（titles被前面设置为[String]）
                titles.append(d["coverTitle"] as! String)
                // 把id传到coverIds里面
                self.coverIds.append(d["id"] as! Int)
                // 颜色字符串
                let colorString = d["coverColor"] as! String
                // 颜色分割字符串， 分割 分割符。要转成rgb色值
                let colorSplitString = colorString.split(separator: ",")
                // colorSplitString是数组，通过获取数组的第n位获取数值
                if colorString != "" {
                    let color = UIColor.rgb(CGFloat(Double(String(colorSplitString[0]))!) * 255, CGFloat(Double(String(colorSplitString[1]))!) * 255, CGFloat(Double(String(colorSplitString[2]))!) * 255)
                    // 添加 颜色
                    colors.append(color)
                }
            }
            
            // 队列，全局队列 回主线程刷新UI
            DispatchQueue.main.async {
                // 赋值数据源，给viewColorModels，里的颜色数组
                self.collectionView!.viewColorModels = colors
                // 赋值数据源，给viewModels，里的字符串数组
                self.collectionView!.viewModels = titles
            }
        }) {
            print($0)
        }
    }
    
     // 添加/新建手帐本 方法
    @objc
    private func addNote() {
        // 初始化控制器
        let vc = UNNoteCreateViewController()
        // 导航栏控制器 “push”（右侧向左推进）。用push方法使界面加入 -- 新建手帐本界面
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    // 删除手帐本
    private func deleteNote() {
        
        // 是否编辑 取反。（删除时 按钮的选中与否）
        deleteSelected = !deleteSelected
        
        if deleteSelected {
            deleteBarItemButton.tintColor = .red
        } else {
            deleteBarItemButton.tintColor = .black
        }
    }
    
    // 退出登录
    @objc
    private func logout() {
        User.shared.logout {
            // 队列
            DispatchQueue.main.async {
                //  弹出登陆界面（bundle“沙盒”，nil默认当前文件夹）
                self.present(UIStoryboard(name: "UNUserLoginViewController", bundle: nil).instantiateViewController(withIdentifier: "UNUserLoginViewController"), animated: true, completion: nil)
                // 是否用动画true，弹出结束nil
            }
        }
    }
}
