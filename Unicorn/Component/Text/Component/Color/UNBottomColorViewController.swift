//
//  UNBottomColorViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBottomColorViewController: UIViewController {
    // 底部一行供选择的颜色
    var colors: [UIColor]? {
        didSet {
            colorCollectionView?.viewColorModels = colors
        }
    }
    // 圆盘颜色
    var colorChange: ((UIColor) -> Void)?
    // 底部颜色变化（从底部选中的颜色）
    var bottomColorChange: ((UIColor) -> Void)?
    // 当前颜色
    var currentColor: UIColor?
    
    private var colorCollectionView: UNLineCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // EFColorPicker颜色选择器
        // 设置HSB色彩圆盘。H色相，S饱和度，B亮度（调用EFHSBView库-色彩圆盘）
        let colorView = EFHSBView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
        // 当前的颜色（保证下次点开颜色盘时还定留在上次选择的颜色）
        if currentColor != nil {
            colorView.color = currentColor!
        }
        // 操作 代理
        colorView.delegate = self
        // 把色盘加进气泡视图里
        view.addSubview(colorView)
        
        // 下方固定颜色的布局 -- 【颜色数组】的集合视图
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 25
        // 内部间距（固定颜色之间的间距）
        let innerW = CGFloat((200 - 5 * itemW) / 5)
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        // 最小行间距
        collectionViewLayout.minimumLineSpacing = innerW
        // 最小项间距
        collectionViewLayout.minimumInteritemSpacing = 10
        // 滚动方向 水平
        collectionViewLayout.scrollDirection = .horizontal
        // 距离四周的间距
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        // 线性集合视图（色盘下方的几个固定颜色选项）
        let colorCollectionView = UNLineCollectionView(frame: CGRect(x: 0, y: colorView.bottom, width: 200, height: 30), collectionViewLayout: collectionViewLayout)
        // 局部变量给全局变量
        self.colorCollectionView = colorCollectionView
        colorCollectionView.backgroundColor = .white
        // 线性集合视图类型
        colorCollectionView.lineType = .color
        // viewColorModels 颜色数组
        // 颜色是UNBottomColorViewController本类父类设置的。固定颜色数组。
        colorCollectionView.viewColorModels = colors
        // 获取到被点击的cell（用反向闭包传值，获取到用户点击的颜色）
        colorCollectionView.cellSelected = { selectedIndex in
            guard self.colors != nil else { return }
            // 根据索引位置判断用哪个颜色（再用闭包将色值传出）
            self.bottomColorChange?(self.colors![selectedIndex])
        }
        view.addSubview(colorCollectionView)
    }
}

// 改变颜色的操作，EFHSBViewDelegate协议 获取颜色
extension UNBottomColorViewController: EFHSBViewDelegate {
    // 当颜色改变时 调用该闭包（didChangeColor已经改变颜色）
    func colorView(_ colorView: EFHSBView, didChangeColor color: UIColor) {
        colorChange?(color)
    }
}
