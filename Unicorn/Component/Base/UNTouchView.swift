//
//  UNTouchView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

// 贴纸基类 共有的 方法 属性
import UIKit

class UNTouchView: UIView {
    private var previousRotation: CGFloat = 0
    
    // 是否被选中
    var isSelected = false {
        didSet {
            // 选中时，关闭按钮 不隐藏。未选中时，隐藏
            if isSelected {
                closeButton.isHidden = false
            } else {
                closeButton.isHidden = true
            }
        }
    }
    // 代理
    var viewDelegate: UNTouchViewProtocol?
    
    private var closeButton = UIButton()
    
    // 初始化方法
    override init(frame: CGRect) {
        // 初始化父类
        super.init(frame: frame)
        // 初始化本类
        initView()
    }
    
    
    override func layoutSubviews() {
        initLayout()
    }
    
    // （必要的）与上面的是一体的
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 私有 方法 初始化
    private func initView() {
        // 是否允许用户交互  Interaction交互
        isUserInteractionEnabled = true
        
        // 设置在 normal 情况下的背景图片

        // 关闭按钮（UIImage的名称）
        closeButton.setImage(UIImage(named: "story_maker_close"), for: .normal)
        closeButton.backgroundColor = .black
        // 圆角半径
        closeButton.layer.cornerRadius = 12
        // 裁剪（切割超出圆角范围的子视图）
        closeButton.layer.masksToBounds = true
        // 不点击时 按钮隐藏
        closeButton.isHidden = true
        // 添加触摸事件（按钮目标事件）（事件是给谁代理的-本类）， 两者省略selector（用来选择方法的选择器），状态（按钮按下后才可执行））
        closeButton.addTarget(self, action: .close, for: .touchUpInside)
        
        // pinchGesture 缩放手势（受理-当前类，调用方法）
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: .pinch)
        pinchGesture.delegate = self
        // 给当前UNSticerView类 ，添加手势识别器
        addGestureRecognizer(pinchGesture)
        
        // rotateGesture 旋转手势
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: .rotate)
        rotateGesture.delegate = self
        // 给当前UNSticerView类 ，添加手势识别器
        addGestureRecognizer(rotateGesture)
        
        // panGesture 拖拽/平移手势
        let panGesture = UIPanGestureRecognizer(target: self, action: .pan)
        panGesture.delegate = self
        // 给当前UNSticerView类 ，添加手势识别器
        addGestureRecognizer(panGesture)
        
        // TapGesture 单击/点击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: .doubleTap)
        // 双击，设置所需的点击次数
        tapGesture.numberOfTapsRequired = 2
        // 给当前UNSticerView类 ，添加手势识别器
        addGestureRecognizer(tapGesture)
    }
    

    // 添加进视图（关闭按钮要在贴纸左上角）
    private func initLayout() {
        closeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        // 位置-在零点
        closeButton.center = .zero
        addSubview(closeButton)
    }
    
    // 关闭按钮的点击方法 （点击关闭按钮 移除贴纸）
    @objc
    // 文件私有(文件内可调用这个方法)。 【 文件私有的范围 > 类私有 】
    fileprivate func closeButtonClick() {
        // 此处考虑到在删除时提示用户。。
        // 是否遵守代理
        if viewDelegate != nil {
            // 遵守。执行方法
            viewDelegate!.UNTouchViewCloseButtonClick(sticker: self)
        } else {
            // 不遵守。移除当前视图
            removeFromSuperview()
        }
    }
    
    // pinchGesture 缩放手势
    // 缩放的方法（文件私有）。  gesture手势 ：UI缩放手势识别器
    @objc
    fileprivate func pinchImage(gesture: UIPinchGestureRecognizer) {
        //  当前手势 状态   改变中
        if gesture.state == .changed {
            // 当前矩阵2D变换  缩放通过（手势缩放的参数）
            transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
            // 要复原到1（原尺寸），不要叠加放大（放大3缩小1）
            gesture.scale = 1
        }
    }
    
    // rotateGesture 旋转手势
    // 旋转的方法（文件私有）。  gesture手势 ：UI旋转手势识别器
    @objc
    fileprivate func rotateImage(gesture: UIRotationGestureRecognizer) {
        if gesture.state == .changed {
            // 该手势中包含 手势旋转的弧度
            transform = transform.rotated(by: gesture.rotation)
            // 0为弧度制（要跟角度转换）
            gesture.rotation = 0
        }
    }
    
    // panGesture 拖拽/平移手势
    // 平移的方法（文件私有）。  gesture手势 ：UI平移手势识别器
    @objc
    fileprivate func panImage(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            // 坐标转换至父视图坐标
            let gesturePosition = gesture.translation(in: superview)
            // 用移动距离与原位置坐标计算。 gesturePosition.x 已经带正负了
            center = CGPoint(x: center.x + gesturePosition.x, y: center.y + gesturePosition.y)
            // .zero 为 CGPoint(x: 0, y: 0)的简写， 位置坐标回0
            gesture.setTranslation(.zero, in: superview)
        }
    }
    
    // 双击动作（UI点击手势识别器）
    @objc
    fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
        // 状态 双击结束后
        if tap.state == .ended {
            // 翻转 90度
            let ratation = CGFloat(Double.pi / 2.0)
            // 变换   旋转角度 = 之前的旋转角度 + 旋转
            transform = CGAffineTransform(rotationAngle: previousRotation + ratation)
            previousRotation += ratation
        }
    }
}

// Selector的私有拓展   selector：用来选择方法的选择器 （使用时简便）
private extension Selector {
    static let close = #selector(UNTouchView.closeButtonClick)
    static let pinch = #selector(UNStickerView.pinchImage(gesture:))
    static let rotate = #selector(UNStickerView.rotateImage(gesture:))
    static let pan = #selector(UNStickerView.panImage(gesture:))
    static let doubleTap = #selector(UNStickerView.doubleTapGesture(tap:))
}

extension UNTouchView: UIGestureRecognizerDelegate {

    // 是否允许多手势（是否在执行当前手势时 允许其他手势发生）
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// 协议 （通过协议向外传值）
protocol UNTouchViewProtocol {
    // 定义协议里的方法（但 是VC去实现方法，决定方法的作用）
    func UNTouchViewCloseButtonClick(sticker: UNTouchView)
}

// 拓展 协议。（属于实现 所以不可写在定义里）
private extension UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick(sticker: UNTouchView) {}
}

