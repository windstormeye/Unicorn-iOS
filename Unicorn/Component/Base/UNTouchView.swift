//
//  UNTouchView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTouchView: UIView {
    var touched: ((UNTouchView) -> Void)?
    
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
        closeButton.addTarget(self, action: .close, for: .touchUpInside)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: .pinch)
        pinchGesture.delegate = self
        addGestureRecognizer(pinchGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: .rotate)
        rotateGesture.delegate = self
        addGestureRecognizer(rotateGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: .pan)
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
    }
    
    private func initLayout() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        closeButton.center = .zero
        addSubview(closeButton)
    }
    
    @objc
    fileprivate func closeButtonClick() {
        if viewDelegate != nil {
            viewDelegate!.UNTouchViewCloseButtonClick(sticker: self)
        } else {
            removeFromSuperview()
        }
    }
    
    @objc
    fileprivate func pinchImage(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1
            
            touched?(self)
        }
    }
    
    @objc
    fileprivate func rotateImage(gesture: UIRotationGestureRecognizer) {
        if gesture.state == .changed {
            transform = transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
            
            touched?(self)
        }
    }
    
    @objc
    fileprivate func panImage(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let gesturePosition = gesture.translation(in: superview)
            center = CGPoint(x: center.x + gesturePosition.x, y: center.y + gesturePosition.y)
            gesture.setTranslation(.zero, in: superview)
            
            touched?(self)
        }
    }
}

private extension Selector {
    static let close = #selector(UNTouchView.closeButtonClick)
    static let pinch = #selector(UNSticerView.pinchImage(gesture:))
    static let rotate = #selector(UNSticerView.rotateImage(gesture:))
    static let pan = #selector(UNSticerView.panImage(gesture:))
}

extension UNTouchView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

protocol UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick(sticker: UNTouchView)
}

private extension UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick(sticker: UNTouchView) {}
}

