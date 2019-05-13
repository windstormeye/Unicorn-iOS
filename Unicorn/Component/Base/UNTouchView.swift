//
//  UNTouchView.swift
//  Unicorn
//
//  Created by YiYi on 2019/3/25.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

class UNTouchView: UIView {
    private var previousRotation: CGFloat = 0
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: .doubleTap)
        // 双击
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
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
        }
    }
    
    @objc
    fileprivate func rotateImage(gesture: UIRotationGestureRecognizer) {
        if gesture.state == .changed {
            transform = transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    
    @objc
    fileprivate func panImage(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let gesturePosition = gesture.translation(in: superview)
            center = CGPoint(x: center.x + gesturePosition.x, y: center.y + gesturePosition.y)
            gesture.setTranslation(.zero, in: superview)
        }
    }
    
    @objc
    fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            let ratation = CGFloat(Double.pi / 2.0)
            transform = CGAffineTransform(rotationAngle: previousRotation + ratation)
            previousRotation += ratation
        }
    }
}

private extension Selector {
    static let close = #selector(UNTouchView.closeButtonClick)
    static let pinch = #selector(UNSticerView.pinchImage(gesture:))
    static let rotate = #selector(UNSticerView.rotateImage(gesture:))
    static let pan = #selector(UNSticerView.panImage(gesture:))
    static let doubleTap = #selector(UNSticerView.doubleTapGesture(tap:))
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

