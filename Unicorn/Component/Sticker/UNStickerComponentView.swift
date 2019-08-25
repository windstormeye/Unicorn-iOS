//
//  UNStickerComponentView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/29.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNStickerComponentView: UIView {
    var sticker: ((UNStickerView) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // “贴纸”界面初始化
    private func initView() {
        backgroundColor = .lightGray
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 70
        let itemCount = CGFloat(5)
        let innerW = (width - itemCount * 50) / itemCount
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        // 距离四周的间距
        collectionViewLayout.sectionInset = UIEdgeInsets(top: innerW / 2, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.lineType = .icon
        // iconTitle里设置默认为“home-”开头，但这里设为“贴纸”开头的 图（文件夹Assets里的资源）
        collectionView.iconTitle = "贴纸"
        collectionView.iconCount = 17
        addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            let stickerImage = UIImage(named: collectionView.iconTitle + "\(cellIndex)")
            let sticker = UNStickerView()
            sticker.width = 100
            sticker.height = 100
            sticker.imgViewModel = UNStickerView.ImageStickerViewModel(image: stickerImage!)
            self.sticker?(sticker)
        }
        
        
        // 顶左、右圆角
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight],
                                    cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

}
