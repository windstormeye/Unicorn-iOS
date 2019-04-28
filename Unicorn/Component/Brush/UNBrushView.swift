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
    /// 可撤回集合
    private var redoDatas = [Data]()
    /// 可重做集合
    private var undoDatas = [Data]()
    
    
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
        redoDatas.removeAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(bgView)
        
        canvaView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        bgView.addSubview(canvaView)
        
        let undoButton = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        addSubview(undoButton)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        undoButton.backgroundColor = .red
        
        let redoButton = UIButton(frame: CGRect(x: 100, y: 250, width: 100, height: 100))
        addSubview(redoButton)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        redoButton.backgroundColor = .blue
    }
    
    @objc
    private func erase() {
        if brushWidth != 10 {
            brushColor = .black
            brushWidth = 10
        } else {
            brushColor = .white
            brushWidth = 3
        }
    }
    
    @objc
    private func undo() {
        guard undoDatas.count != 0 else { return }
        
        // 如果是撤回集合中只有 1 个数据，则说明撤回后为空
        if undoDatas.count == 1 {
            redoDatas.append(undoDatas.last!)
            undoDatas.removeLast()
            bgView.image = nil
        } else {
            redoDatas.append(undoDatas.last!)
            undoDatas.removeLast()
            bgView.image = nil
            bgView.image = UIImage(data: undoDatas.last!)
        }
    }
    
    @objc
    private func redo() {
        if redoDatas.count > 0 {
            // 先赋值，再移除
            bgView.image = UIImage(data: redoDatas.last!)
            undoDatas.append(redoDatas.last!)
            redoDatas.removeLast()
        }
    }
    
    override func layoutSubviews() {
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        canvaView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let beginPoint = touches.first?.location(in: self)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: beginPoint!)
        let brush = UNBrush(color: brushColor, width: brushWidth, bezierPath: bezierPath)
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
        canvaView.brunsh(brush: brush)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let context = UIGraphicsGetCurrentContext()
        bgView.layer.render(in: context!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bgView.image = bgImage
        undoDatas.append(bgImage!.pngData()!)
        canvaView.brunsh(brush: nil)
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
