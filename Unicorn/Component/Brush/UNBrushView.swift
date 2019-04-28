//
//  UNBrushView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/28.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBrushView: UIView {
    /// 画笔颜色
    var brushColor: UIColor = .white
    /// 画笔宽度
    var brushWidth: CGFloat = 3
    
    /// 笔画数
    private(set) var brushes = [UNBrush]()
    /// 绘制层
    private var canvaView = UNCanvaView()
    /// 显示层
    private var bgView = UIImageView()
    /// 存储绘制一次贝塞尔曲线的点集合
    private var points = Array(repeating: CGPoint(), count: 5)
    /// 标识当前存储的点索引
    private var pointIndex = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    deinit {
        clean()
    }
    
    private func clean() {
        bgView.image = nil
        brushes.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(bgView)
        
        canvaView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        bgView.addSubview(canvaView)
    }
    
    override func layoutSubviews() {
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        canvaView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let beginPoint = touches.first?.location(in: self)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: beginPoint!)
        let brush = UNBrush(color: .white, width: 3, bezierPath: bezierPath)
        brushes.append(brush)
        
        pointIndex = 0
        points[0] = beginPoint!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let movedPoint = touches.first?.location(in: self)
        let brush = brushes.last
        
        pointIndex += 1
        points[pointIndex] = movedPoint!
        
        if pointIndex == 4 {
            let p_x = (points[2].x + points[4].x) / 2
            let p_y = (points[2].y + points[4].y) / 2
            points[3] = CGPoint(x: p_x, y: p_y)
            
            // 绘制 “三次贝塞尔曲线”
            // 绘制三次贝塞尔曲线的关键方法,以三个点画一段曲线. 一般和 `moveToPoint:` 配合使用.
            // 起始点为 pts[0] 设置,终止点位为 pts[3]，控制点 1 的坐标 pts[1]，控制点2的坐标是 pts[2]
            brush?.bezierPath.move(to: points[0])
            brush?.bezierPath.addCurve(to: points[3],
                                       controlPoint1: points[1],
                                       controlPoint2: points[2])
            
            points[0] = points[3]
            points[1] = points[4]
            pointIndex = 1
        }
        canvaView.brunsh(brush: brush!)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let context = UIGraphicsGetCurrentContext()
        bgView.layer.render(in: context!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        bgView.image = bgImage
    }
    
    func drawImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        bgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return bgImage!
    }

}

extension UNBrushView {
    struct UNBrush {
        // 画笔颜色
        var color: UIColor
        // 画笔宽度
        var width: CGFloat
        // 画笔路径
        var bezierPath: UIBezierPath
    }
}
