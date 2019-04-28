//
//  UNCanvaView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/28.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNCanvaView: UIView {
    /// 告知系统当前 UIView.layer = CAShapeLayer
    override class var layerClass : AnyClass {
        return CAShapeLayer.self
    }
    
    /// 设置画笔
    func brunsh(brush: UNBrushView.UNBrush?) {
        let shapeLayer = self.layer as! CAShapeLayer
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        
        if brush != nil {
            shapeLayer.lineWidth = brush!.width
            shapeLayer.strokeColor = brush!.color.cgColor
            shapeLayer.path = brush!.bezierPath.cgPath
        } else {
            shapeLayer.path = nil
        }
    }
}
