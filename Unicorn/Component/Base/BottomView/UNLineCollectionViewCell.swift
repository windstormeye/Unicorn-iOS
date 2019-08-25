//
//  UNLineCollectionViewCell.swift
//  WWDC19
//
//  Created by PJHubs on 2019/3/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNLineCollectionViewCell: UICollectionViewCell {
    // 字符串类型的viewModel
    var viewModel = "" {
        // 已经赋值
        didSet {
            setViewModel()
        }
    }
    // 把颜色设置为背景颜色
    var viewColorModel: UIColor? {
        didSet {
            backgroundColor = viewColorModel
        }
    }
    // 把图片设置为图标
    var image: UIImage? { didSet{iconImageView?.image = image }}
    // 设置类型
    var type: UNLineCollectionView.LineType = .text {didSet{setType()}}
    
    // tipsLabel：cell里的文字
    private var tipsLabel: UILabel?
    // iconImageView：cell里的view
    private var iconImageView: UIImageView?
    
    // CGRect类 有 xy宽高属性
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    // 初始化编码器
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        // tipsLabel：cell里的文字
        let tipLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        tipLabel.text = viewModel
        // 文本对齐方式
        tipLabel.textAlignment = .center
        tipLabel.textColor = .white
        self.tipsLabel = tipLabel
        // 添加子视图
        addSubview(tipLabel)
        
        // iconImageView：cell里的view
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(iconImageView)
        self.iconImageView = iconImageView
        // 内容模式 = Fit 匹配（按比例合适）
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setViewModel() {
        tipsLabel!.text = viewModel
    }
    
    private func setType() {
        switch type {
            
        // 字（字体部分下方栏）
        case .text:
            // 文本
            tipsLabel?.isHidden = false
            // View
            iconImageView?.isHidden = true
        
        // 颜色
        case .color:
            tipsLabel?.isHidden = true
            iconImageView?.isHidden = true
            backgroundColor = viewColorModel
            // 圆角
            layer.cornerRadius = width / 2
           
        // 图标
        case .icon:
            iconImageView?.isHidden = false
            // scale 缩放，将图标缩放0.7倍
            iconImageView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            
        // 封面
        case .cover:
            iconImageView?.isHidden = true
            tipsLabel?.isHidden = false
            tipsLabel?.height = 20
            tipsLabel?.left = 5
            // width = width - 5
            tipsLabel?.width -= 5
            // 手帐本高度-字高度-10（距离手帐本底部10）
            tipsLabel?.top = height - tipsLabel!.height - 10
            tipsLabel?.textAlignment = .left
            // 封面底色
            backgroundColor = viewColorModel
            layer.cornerRadius = 10
        }
    }
}
