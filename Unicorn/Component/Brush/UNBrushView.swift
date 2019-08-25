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
    var brushColor: UIColor = .black
    /// 画笔宽度
    var brushWidth: CGFloat = 3
    
    /// 笔画数 （UNBrush含有颜色 宽度等属性）
    private(set) var brushes = [UNBrush]()
    
    /// 绘制层。【画布视图】UNCanvaView含有画笔属性
    private var canvaView = UNCanvaView()
    /// 显示层（画笔画完生成图片所占view）
    private var bgView = UIImageView()
    /// 存储绘制一次贝塞尔曲线的点集合
    private var points = Array(repeating: CGPoint(), count: 5)
    /// 标识当前存储的点索引
    private var pointIndex = 0
    /// 可重做集合
    private var redoDatas = [Data]()
    /// 可撤回集合
    private var undoDatas = [Data]()
    /// 底部功能栏
    private var bottomView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
//    deinit {
//        clean()
//    }
//
//    private func clean() {
//        bgView.image = nil
//        brushes.removeAll()
//        redoDatas.removeAll()
//    }
//
    
    // 解码器
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        // 底部视图（底部功能栏）
        bottomView.frame = CGRect(x: 0, y: height - 50, width: width, height: 50)
        addSubview(bottomView)
        bottomView.backgroundColor = .lightGray
        
        // 显示层：画笔画完后生成图片，所占view（是UIImageView）
        bgView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(bgView)
        // 画布视图。canvaView是UNCanvaView类 含有画笔属性
        canvaView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        bgView.addSubview(canvaView)
        
        /// 撤回
        let undoButton = UIButton(frame: CGRect(x: 0, y: 0, width: bottomView.height, height: bottomView.height))
        bottomView.addSubview(undoButton)
        // 图标
        undoButton.setImage(UIImage(named: "back"), for: .normal)
        undoButton.addTarget(self, action: #selector(undo), for: .touchUpInside)
        
        /// 重做
        let redoButton = UIButton(frame: CGRect(x: undoButton.right + 10, y: 0, width: bottomView.height, height: bottomView.height))
        bottomView.addSubview(redoButton)
        // 图标
        redoButton.setImage(UIImage(named: "return"), for: .normal)
        redoButton.addTarget(self, action: #selector(redo), for: .touchUpInside)
        
        /// 颜色选择
        // 集合视图布局
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = bottomView.height * 0.7
        // 数量
        let itemCount = CGFloat(5)
        // 内部
        let innerW = (screenWidth - itemCount * 50) / itemCount
        // 宽高大小
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        // 最小行间距
        collectionViewLayout.minimumLineSpacing = innerW
        // 最小项间距
        collectionViewLayout.minimumInteritemSpacing = 10
        // 滚动方向 水平
        collectionViewLayout.scrollDirection = .horizontal
        // 距离四周的间距
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        // 集合视图 位置xy宽高 redo重做（颜色在redo的右边）
        let collectionView = UNLineCollectionView(frame: CGRect(x: redoButton.right, y: 0, width: bottomView.width - redoButton.right, height: bottomView.height), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        // 线性集合视图类型
        collectionView.lineType = .color
        collectionView.viewColorModels = [.black, .red, .gray, .green, .purple, .blue]
        bottomView.addSubview(collectionView)
        
        // 选中cell，重复点击 宽度增加
        collectionView.cellSelected = { cellIndex in
            // viewColorModels 颜色数组
            // 判断颜色是否一样（笔刷颜色-当前选择颜色）
            if self.brushColor == collectionView.viewColorModels![cellIndex] {
                self.brushWidth += 1
            } else {
                self.brushWidth = 3
            }
            // 把画笔颜色赋值回去
            self.brushColor = collectionView.viewColorModels![cellIndex]
        }
        
        // “画布视图”canvaView 里会使用UNBrush结构体
        // 画笔颜色、粗细赋值后，给“画布视图”canvaView
    }
    
    
    // undo 撤回
    @objc
    private func undo() {
        // undoDatas 可撤回集合 数量
        guard undoDatas.count != 0 else { return }
        
        // 如果是撤回集合中只有 1 个数据，则说明撤回后为空
        if undoDatas.count == 1 {
            // 重做 redo  append 添加
            redoDatas.append(undoDatas.last!)
            // 撤回 undo 清空
            undoDatas.removeLast()
            // 清空图片视图
            bgView.image = nil
        } else {
            // 把 3 给 redo
            redoDatas.append(undoDatas.last!)
            // 从 undo 移除 3. 还剩 2 1
            undoDatas.removeLast()
            // 清空图片视图
            bgView.image = nil
            // 把 2 给图片视图
            bgView.image = UIImage(data: undoDatas.last!)
        }
    }
    
    // redo 重做
    @objc
    private func redo() {
        if redoDatas.count > 0 {
            // 先赋值，再移除（redo的last给图片视图）
            bgView.image = UIImage(data: redoDatas.last!)
            // redo的last 给 undo撤回数组
            undoDatas.append(redoDatas.last!)
            // 从redo重做 移除last
            redoDatas.removeLast()
        }
    }
    
    // --- 绘制起始点 ---
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取起始点
        let beginPoint = touches.first?.location(in: self)
        // 贝塞尔曲线
        let bezierPath = UIBezierPath()
        // 路径起点
        bezierPath.move(to: beginPoint!)
        let brush = UNBrush(color: brushColor, width: brushWidth, bezierPath: bezierPath)
        // 所有画笔的集合（里面有 画笔的颜色宽度路径属性）
        brushes.append(brush)
        // 三次方贝塞尔曲线的起始点，这一次的三次贝塞尔画完了，连接下一次的
        pointIndex = 0
        points[0] = beginPoint!
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let movedPoint = touches.first?.location(in: self)
        // brushes中含有画笔属性
        let brush = brushes.last
        
        // 拿到一个点后++，存储点
        pointIndex += 1
        points[pointIndex] = movedPoint!
        
        if pointIndex == 4 {
            // 4为下一个控制点
            let p_x = (points[2].x + points[4].x) / 2
            let p_y = (points[2].y + points[4].y) / 2
            points[3] = CGPoint(x: p_x, y: p_y)

            // 绘制 “三次贝塞尔曲线”
            // 绘制三次贝塞尔曲线的关键方法,以三个点画一段曲线. 一般和 `moveToPoint:` 配合使用.
            // 起始点为 pts[0] 设置,终止点位为 pts[3]，控制点 1 的坐标 pts[1]，控制点2的坐标是 pts[2]
            
            // 移到起始点
            brush?.bezierPath.move(to: points[0])
            // 添加曲线
            brush?.bezierPath.addCurve(to: points[3],
                                       controlPoint1: points[1],
                                       controlPoint2: points[2])
    
            // 延续三次贝塞尔曲线点
            // 终点->起点。
            points[0] = points[3]
            // 控制点
            points[1] = points[4]
            pointIndex = 1
        }
        // 画布
        canvaView.brunsh(brush: brush)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 开启图形上下文（“创建容器”）
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        // UIGraphics API ，GetCurrentContext获取当前上下文
        let context = UIGraphicsGetCurrentContext()
        // 把view的layer放进上下文
        bgView.layer.render(in: context!)
        // 获取图片，来自当前开启的上下文（笔迹变成图片）
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭当前打开的上下文
        UIGraphicsEndImageContext()
        
        bgView.image = bgImage
        // 转成png类型的二进制数据
        undoDatas.append(bgImage!.pngData()!)
        // 每次画完都要从画布上清除最后一笔
        canvaView.brunsh(brush: nil)
    }
    
    func drawImage() -> UIImage {
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, UIScreen.main.scale)
        // 填充该上下文到背景View中
        bgView.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 获取图片，来自当前开启的上下文
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭当前打开的上下文
        UIGraphicsEndImageContext()
        
        return bgImage!
    }
}

// 画笔结构体
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
