//
//  UNSticerView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 封装基类
class UNStickerView: UNTouchView {
    // 贴纸类型（两种类型：默认类型-贴纸； 用户自定义类型-照片、文字）
    var stickerType: StickerType = .default
    // 贴纸id
    var id: Int?
    
    // 照片贴纸数据源
    var imgViewModel: ImageStickerViewModel? {
        didSet {
            imageStickerView.image = imgViewModel!.image
            stickerType = .custom //照片、文字被认为是自定义类型
        }
    }
    
    // 文字贴纸数据源
    var textViewModel: TextStickerViewModel? {
        didSet {
            textStickerView.viewModel = textViewModel!
            stickerType = .custom
        }
    }
    
    // 图片视图
    lazy var imageStickerView: UIImageView = {
        let imageStickerView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageStickerView.layer.borderColor = UIColor.lightGray.cgColor
        // 内容模式 - 按比例充满
        imageStickerView.contentMode = .scaleAspectFit
        // imageStickerView.layer.masksToBounds = true
        addSubview(imageStickerView)
        return imageStickerView
    }()
    
    // 文字/标签视图
    lazy var textStickerView: UNLabel = {
        let textStickerView = UNLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        // 换行模式
        textStickerView.lineBreakMode = .byWordWrapping
        // 0 相当于不限制行数
        textStickerView.numberOfLines = 0
        addSubview(textStickerView)
        return textStickerView
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageStickerView.layer.borderWidth = 1
            } else {
                imageStickerView.layer.borderWidth = 0
            }
        }
    }
}

extension UNStickerView {
    // 照片数据源-结构体
    struct ImageStickerViewModel {
        let image: UIImage
    }
    
    // 文字贴纸数据源类型-结构体
    struct TextStickerViewModel {
        let text: String
        let textColor: UIColor
        let textFont: UIFont
    }
    
    // 贴纸类型（默认类型-贴纸；自定义类型-文字、照片）- 结构体
    enum StickerType: Int {
        case `default` = 0
        case custom //自定义类型
    }
}


class UNLabel: UILabel {
    var viewModel: UNStickerView.TextStickerViewModel? {
        didSet {
            font = viewModel?.textFont
            textColor = viewModel?.textColor
            text = viewModel?.text
        }
    }
}
