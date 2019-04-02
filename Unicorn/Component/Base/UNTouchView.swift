//
//  UNTouchView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTouchView: UIView {

    var isSelected = false {
        didSet {
            if isSelected {
                closeButton.isHidden = false
            } else {
                closeButton.isHidden = true
            }
        }
    }
    var viewDelegate: UNTouchViewProtocol?
    
    private var closeButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    override func layoutSubviews() {
        initLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        isUserInteractionEnabled = true
        
        closeButton.setImage(UIImage(named: "story_maker_close"), for: .normal)
        closeButton.backgroundColor = .black
        closeButton.layer.cornerRadius = 12
        closeButton.layer.masksToBounds = true
        closeButton.isHidden = true
    }
    
    private func initLayout() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        closeButton.center = .zero
        addSubview(closeButton)
    }
    
    @objc
    fileprivate func closeButtonClick() {
        if viewDelegate != nil {
            viewDelegate!.UNTouchViewCloseButtonClick()
        } else {
            removeFromSuperview()
        }
    }
}

private extension Selector {
    static let close = #selector(UNTouchView.closeButtonClick)
}


protocol UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick()
}

private extension UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick() {}
}
