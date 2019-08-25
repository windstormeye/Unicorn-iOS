//
//  UNCanvaView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/28.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 画布视图
class UNCanvaView: UIView {
    /// 告知系统当前 UIView.layer = CAShapeLayer
    override class var layerClass : AnyClass {
        /* CAShapeLayer属于QuartzCore框架，是在坐标系内绘制贝塞尔曲线的
         含有属性：指定图像的路径，填充颜色、描边颜色等样式属性 */
        return CAShapeLayer.self
    }
    
    /// 设置画笔
    // 通过 UNBrush结构体 完成
    func brunsh(brush: UNBrushView.UNBrush?) {
        let shapeLayer = self.layer as! CAShapeLayer
        // 设置填充颜色
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 线拐点的样式（拐点圆滑）
        shapeLayer.lineJoin = .round
        // 线端点的样式（端点圆滑）
        shapeLayer.lineCap = .round
        
        if brush != nil {
            // 描边的宽度，默认为1
            shapeLayer.lineWidth = brush!.width
            // 描边颜色
            shapeLayer.strokeColor = brush!.color.cgColor
            // 路径
            shapeLayer.path = brush!.bezierPath.cgPath
        } else {
            shapeLayer.path = nil
        }
    }
}
