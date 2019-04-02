//
//  UNSticerView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNSticerView: UNTouchView {

    var stickerImage: UIImage? {
        didSet { stickerImageView.image = stickerImage }
    }
    
    private var stickerImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        stickerImageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        stickerImageView.layer.borderColor = UIColor.white.cgColor
        stickerImageView.contentMode = .scaleAspectFit
        addSubview(stickerImageView)
        
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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                stickerImageView.layer.borderWidth = 1
            } else {
                stickerImageView.layer.borderWidth = 0
            }
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
}

private extension Selector {
    static let pinch = #selector(UNSticerView.pinchImage(gesture:))
    static let rotate = #selector(UNSticerView.rotateImage(gesture:))
    static let pan = #selector(UNSticerView.panImage(gesture:))
}

extension UNSticerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
