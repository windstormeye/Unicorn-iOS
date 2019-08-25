//
//  UNShowContentCollectionView.swift
//  WWDC19
//
//  Created by PJHubs on 2019/3/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 线性 集合视图：底部选择器（下栏按钮）类
class UNLineCollectionView: UICollectionView {
    // cell 标识符
    private let cellIdentifier = "UNLineCollectionViewCell"
    // 字符串数组。reloadData刷新数据
    var viewModels: [String]? {didSet{ reloadData()}}
    // 颜色数组 （reloadData 给数据的时候 刷新数据）
    var viewColorModels: [UIColor]? {didSet{ reloadData()}}
    // 每一个cell中心的x
    var cellCenterXs = [CGFloat]()
    // 不赋值的话 默认为text
    var lineType: LineType = .text
    // 资源文件Assets里的 图标的名称
    var iconTitle = "home-"
    var iconCount = 5
    // 闭包-反向传值
    var cellSelected: ((Int) -> Void)?
    // 长按闭包
    var longCellSelected: ((Int) -> Void)?
    
    // 重载 初始化方法
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: layout)
        // 初始化视图
        initView()
    }
    
    // 初始化。aDecoder解码器。（与上述一体）
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        // 展示水平滚动器
        showsHorizontalScrollIndicator = false
        // 是否分页功能（否的话，滑动就停止了，没有分页的流畅效果）
        isPagingEnabled = true
        
        // 用这个类：PJLineCollectionView，来处理这个视图： UICollectionView
        delegate = self
        // 自己处理自己的数据源
        dataSource = self
        
        // 要将cell注册进视图里，给cell标识符
        register(UNLineCollectionViewCell.self,
                 forCellWithReuseIdentifier: "UNLineCollectionViewCell")
    }
}

// Delegate 代理操作
extension UNLineCollectionView: UICollectionViewDelegate {
    // didSelectItemAt 选中一个Item (点击按钮的响应事件)
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        // 闭包反向传值（传给父视图）
        cellSelected?(indexPath.row)
    }
}

// DataSource 数据源
extension UNLineCollectionView: UICollectionViewDataSource {
    // 设置组内有几个内容 numberOfItemsInSection。section 一条为一个组
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        // 判断一下类型，因为选颜色和下栏按钮的形式不一样。
        // 所以分为四类。返回的数据源的个数不一样。
        switch lineType {
        case .text:
            // let常量。判空。
            guard let viewModels = viewModels else { return 0 }
            // 返回数据源个数
            return viewModels.count
        case .color:
            guard let viewColorModels = viewColorModels else { return 0 }
            return viewColorModels.count
        case .icon:
            return iconCount
        case .cover:
            guard let viewColorModels = viewColorModels else { return 0 }
            return viewColorModels.count
        }
        
    }
    
    // 每一个cell里的Item。定义内容。
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 取队列可重用的cell。
        // withReuseIdentifier 伴随着重用标识符。 强转类型：as! PJLineCollectionViewCell。
        // 索引路径 indexPath
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UNLineCollectionViewCell", for: indexPath) as! UNLineCollectionViewCell
        // 区别类型。
        cell.type = lineType
        
        switch lineType {
        case .text:
            // 给viewModel 赋值数据源。（viewModels：字符串数组-按钮名称）
            cell.viewModel = viewModels![indexPath.row]
        case .color:
            // 给viewColorModel 赋值数据源。（viewColorModels：UIColor数组）
            cell.viewColorModel = viewColorModels![indexPath.row]
        case .icon:
            cell.image = UIImage(named: iconTitle + "\(indexPath.row)")
        case .cover: //封面
            // indexPath 索引路径
            cell.viewColorModel = viewColorModels![indexPath.row]
            cell.viewModel = viewModels![indexPath.row]
            cell.layer.shadowColor = UIColor.black.cgColor
            // 阴影偏移
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            // 阴影透明度
            cell.layer.shadowOpacity = 0.4
        }
        // 把cell的中心值传出，用于设置点击后的气泡位置
        cellCenterXs.append(cell.center.x)
        
        return cell
    }
}

// 枚举
extension UNLineCollectionView {
    enum LineType {
        case text
        case color
        case icon
        case cover 
    }
}

