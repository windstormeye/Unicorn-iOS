//
//  UNSticerView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNSticerView: UNTouchView {
    var imgViewModel: ImageStickerViewModel? {
        didSet { imageStickerView.image = imgViewModel!.image }
    }
    
    var textViewModel: TextStickerViewModel? {
        didSet { textStickerView.viewModel = textViewModel! }
    }
    
    lazy var imageStickerView: UIImageView = {
        let imageStickerView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageStickerView.layer.borderColor = UIColor.white.cgColor
        imageStickerView.contentMode = .scaleAspectFit
        addSubview(imageStickerView)
        return imageStickerView
    }()
    
    lazy var textStickerView: UNLabel = {
        let textStickerView = UNLabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
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

extension UNSticerView {
    struct ImageStickerViewModel {
        let image: UIImage
    }
    
    struct TextStickerViewModel {
        let text: String
        let textColor: UIColor
        let textFont: UIFont
    }
}

// MARK:-
class UNLabel: UILabel {
    var viewModel: UNSticerView.TextStickerViewModel? {
        didSet {
            font = viewModel?.textFont
            textColor = viewModel?.textColor
            text = viewModel?.text
        }
    }
}
