//
//  UNContentViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/3/25.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit
import Alamofire

class UNContentViewController: UIViewController {
    /// 当前编辑页面所属的手帐
    var bookId: Int?
    /// 贴纸集合
    private var stickerViews = [UNStickerView]()
    /// 底部功能栏
    private var bottomCollectionView: UNLineCollectionView?
    /// 照片选择器
    private var imagePicker = UIImagePickerController()
    /// 背景。放笔迹
    private var bgImageView = UIImageView()
    /// 贴纸容器
    private var stickerComponentView = UNStickerComponentView()
    /// 贴纸的起始 tag
    private var stickerTag = 1000
    /// 渐变背景层
    private var gradientLayer = CAGradientLayer()
    /// 渐变背景层颜色集合
    private var bgColors = [CGColor]() {
        // 调用changeGradientLayer
        didSet { self.changeGradientLayer(colors: bgColors) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // 设置背景颜色
        view.backgroundColor = .white
        // 设置导航栏右按钮。
        // 调用done方法，share方法
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(share))]
        
        // 初始化渐变层
        self.view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.view.bounds
        // 从左下角
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        // 到右上角 进行渲染
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        
        // 画笔 - 调用UNBrushView
        let brushView = UNBrushView(frame: CGRect(x: 0, y: topSafeAreaHeight, width: view.width, height: view.height - bottomSafeAreaHeight - 64 - topSafeAreaHeight))
        brushView.isHidden = true
        view.addSubview(brushView)
        
        // 背景图片
        bgImageView.frame = CGRect(x: 0, y: brushView.y, width: view.width, height: brushView.height)
        view.addSubview(bgImageView)
        // 添加
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenView))
        bgImageView.isUserInteractionEnabled = true
        bgImageView.addGestureRecognizer(tap)
        
        // 贴纸容器 界面实例化
        stickerComponentView = UNStickerComponentView(frame: CGRect(x: 0, y: view.height, width: view.width, height: 200))
        // 先隐藏
        stickerComponentView.isHidden = true
        view.addSubview(stickerComponentView)
        // 选择了贴纸后，通过闭包带出选择的贴纸
        stickerComponentView.sticker = {
            // 通过此闭包 拿到用户选择的贴纸
            $0.viewDelegate = self
            // 设置贴纸的中心 - 在当前父视图的中心
            $0.center = self.view.center
            // 给贴纸增加标签。方便删除
            $0.tag = self.stickerTag
            self.stickerTag += 1
            // 把贴纸加到父视图中
            self.view.addSubview($0)
            // 添加到贴纸集合中/贴纸数组
            self.stickerViews.append($0)
        }
        
        // 底部功能栏
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 50
        let itemCount = CGFloat(5)
        let innerW = (screenWidth - itemCount * 50) / itemCount
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        // 距离四周的间距
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64 + bottomSafeAreaHeight), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor(red: 54/255, green: 149/255, blue: 1, alpha: 1)
        self.bottomCollectionView = collectionView
        collectionView.lineType = .icon
        view.addSubview(collectionView)
        
        // 底部的点击事件
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
                // 背景
                case 0:
                    self.stickerComponentView.isHidden = true
                    // 隐藏画笔栏
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    // 出现colorBottomView
                    self.present(self.colorBottomView, animated: true, completion: nil)
                // 贴纸
                case 1:
                    // 隐藏画笔栏
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    // 贴纸组建视图 不隐藏
                    self.stickerComponentView.isHidden = false
                    // 设置0.25秒的弹出动画
                    UIView.animate(withDuration: 0.25, animations: {
                        // 灰色贴纸选择区域的视图的 底部位置 - 是蓝色icon选择栏的高
                        self.stickerComponentView.bottom = self.bottomCollectionView!.y
                        // 如何拿到备选的贴纸，要看stickerComponentView在哪里有选择贴纸后的。。
                    })
                // 文字
                case 2:
                    // 隐藏贴纸视图
                    self.stickerComponentView.isHidden = true
                    // 隐藏画笔
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    // 控制器 -> 编辑文字的界面等
                    let vc = UNTextViewController()
                    // 自底向上弹出
                    self.present(vc, animated: true, completion: nil)
                    // 拿到TextViewControllor里“完成按钮”点击事件返回的viewModel
                    vc.complateHandler = { viewModel in
                        // UNStickerView又做了一层封装。继承于贴纸基类
                        // UNStickerView有很多类型模式：图片类贴纸、文字类贴纸。
                        let stickerLabel = UNStickerView(frame: CGRect(x: 150, y: 150, width: 100, height: 100))
                        self.view.addSubview(stickerLabel)
                        stickerLabel.textViewModel = viewModel
                        // stickerViews贴纸集合/数组（贴纸容器）
                        self.stickerViews.append(stickerLabel)
                    }
                
                // 照片
                case 3:
                    // 隐藏贴纸视图
                    self.stickerComponentView.isHidden = true
                    // 隐藏画笔
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    
                    self.imagePicker.delegate = self
                    // 源类型 - 相册
                    self.imagePicker.sourceType = .photoLibrary
                    // 是否允许编辑
                    self.imagePicker.allowsEditing = true
                    // 弹出
                    self.present(self.imagePicker, animated: true, completion: nil)
                
                // 画笔
                case 4:
                    // 假设已点击贴纸，所以先隐藏贴纸视图才可出画笔
                    self.stickerComponentView.isHidden = true
                    
                    // 画笔视图取消隐藏。brushView里调用UNBrushView
                    brushView.isHidden = false
                    self.bgImageView.image = nil
                    // 把画笔视图移到最前面 防止遮盖（画笔笔迹在最前面）
                    // brushView 里调用UNBrushView
                    self.view.bringSubviewToFront(brushView)
                default: break
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 先拉取已有的贴纸
        Sticker.shared.get(bookId: bookId!, complateHandler: {
            for sticker in $0 {
                DispatchQueue.main.async {
                    let stickerView = UIImageView(frame: CGRect(x: 0, y: self.view.y, width: self.view.width, height: self.view.height - self.bottomCollectionView!.height))
                    stickerView.backgroundColor = .clear
                    let imgData = try? Data(contentsOf: URL(string: sticker["link"] as! String)!)
                    stickerView.image = UIImage(data: imgData!)
                    self.view.addSubview(stickerView)
                    self.view.sendSubviewToBack(stickerView)
                }
            }
        }) {
            print($0)
        }
    }
    
    func saveImage(image: UIImage?) {
        guard let imageToSave = image else {
            return
        }
        
        // 调api（请求上传的接口）
        let urlString = "http://localhost:8080/api/sticker/upload?bookId=\(bookId!)"
        // 图片太大，要做压缩。压缩比例 0.7（有损压缩）
        let imgData = imageToSave.jpegData(compressionQuality: 0.7)!
        // 作为文件 有文件名
        let imageName = "sticker.png"
        // 调用Alamofire库的固定上传方法（上传成品图片）
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file", fileName: imageName, mimeType: "image/png") }, to:urlString) {
                
                switch $0 {
                    // 设置成功时动作 - 返回上一个界面（pop界面）
                case .success(let upload, _, _):
                    // 图片上传进度
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    // 响应返回json
                    upload.responseJSON { response in
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
//                        print("response.result :\(String(describing: response.result.value))")
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
    }
    
    /// 改变背景渐变层
    func changeGradientLayer(colors: [CGColor]) {
        var numbers = [NSNumber]()
        var numberSum: CGFloat = 0
        let temp = CGFloat(1) / CGFloat(colors.count)
        for index in 0..<colors.count {
            numberSum = 1 - temp * CGFloat(index)
            numbers.append(NSNumber(value: Float(numberSum)))
        }
        // 定义颜色位置
        gradientLayer.locations = numbers.reversed()
        // colors是用来渐变的属性
        gradientLayer.colors = colors
    }
    
    /// 完成编辑
    @objc
    private func done() {
        // 开启某个大小的上下文空间
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.width, height: view.height - bottomCollectionView!.height), false, UIScreen.main.scale)
        // 把 view.layer 渲染进当前打开的上下文空间
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 从上下文空间中获取 UIImage
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭
        UIGraphicsEndImageContext()
        // 调用saveImage，保存图片，给服务端
        saveImage(image: bgImage!)
    }
    
    /// 隐藏/显示 贴纸容器
    @objc
    fileprivate func hiddenView() {
        stickerComponentView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            self.stickerComponentView.y = self.view.height
        }) {
            if $0 {
                self.stickerComponentView.isHidden = true
            }
        }
    }
    
    /// 分享
    @objc
    fileprivate func share() {
        
        // --- 拿到图片 ---
        // 开启某个大小的上下文空间
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.width, height: view.height - bottomCollectionView!.height), false, UIScreen.main.scale)
        // 把 view.layer 渲染进当前打开的上下文空间
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 从上下文空间中获取 UIImage
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭
        UIGraphicsEndImageContext()
        
        // 把图片拿到
        let items = [ bgImage ]
        let toVC = UIActivityViewController(activityItems: items as [Any],
                                            applicationActivities: nil)
        present(toVC, animated: true, completion: nil)
        // 使用项目处理器完成
        toVC.completionWithItemsHandler = {(_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void in
            if completed {
                print("分享成功")
            }
        }
    }

    /// --- 颜色 --- 底部视图 颜色选择器
    private var colorBottomView: UNBottomColorViewController {
        get {
            // 颜色弹窗。初始化 视图控制器（在UNBottomColorViewController中布局）
            let colorPopover = UNBottomColorViewController()
            // 设置供选择的基础颜色
            colorPopover.colors = [UIColor.black, UIColor.white, UIColor.red, UIColor.blue, UIColor.green]
            // 颜色轮盘的 当前选中颜色 是 当前背景颜色
            colorPopover.currentColor = self.view.backgroundColor!
            // 推荐内容大小
            colorPopover.preferredContentSize = CGSize(width: 200, height: 280)
            // 模式展示风格 气泡样式
            colorPopover.modalPresentationStyle = .popover
            
            // 设置颜色弹窗的展示控制器（取出 设置弹窗的属性）
            let colorPopoverPVC = colorPopover.popoverPresentationController
            // 源视图 所依赖的视图。（箭头指向底部功能栏）
            colorPopoverPVC?.sourceView = self.bottomCollectionView
            // 在源视图中的位置。（底部功能栏 cell数组，指向cell中心点）
            colorPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[0], y: 0, width: 0, height: 0)
            // 箭头的朝向 向下
            colorPopoverPVC?.permittedArrowDirections = .down
            colorPopoverPVC?.delegate = self
            colorPopoverPVC?.backgroundColor = .white
            // 颜色轮盘。colorChange
            colorPopover.colorChange = {
                // 在圆盘选色时，调用该闭包 传出用户在轮盘上滚动时选出的颜色
                self.view.backgroundColor = $0
                // 设置背景颜色后，要把渐变颜色的数组清除。避免冲突
                self.bgColors.removeAll()
            }
            // 底部颜色栏
            colorPopover.bottomColorChange = {
                // 选择底部颜色后，就要覆盖背景颜色
                self.bgColors.append($0.cgColor)
            }
            
            return colorPopover
        }
    }
}

// MARK: Touch
extension UNContentViewController {
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: view)
        var isSelected = false
        
        // 判断是否选中，来决定是否显示“选中框”（stickerViews贴纸数组）
        for stickerView in stickerViews {
            if stickerView.frame.contains(touchPoint!) && !isSelected {
                stickerView.isSelected = true
                isSelected = true
            } else {
                stickerView.isSelected = false
            }
        }
    }
}

extension UNContentViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


// ------ 照片 -------
extension UNContentViewController: UIImagePickerControllerDelegate {
    /// 从图片选择器中获取选择到的图片（已经完成媒体选择：选择的照片）
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 获取到编辑后的图片
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image != nil {
            // wh 计算宽高比
            let wh = image!.size.width / image!.size.height
            // 初始化贴纸
            let sticker = UNStickerView(frame: CGRect(x: 150, y: 150, width: 100, height: 100 * wh))
            // 添加视图
            self.view.addSubview(sticker)
            sticker.imgViewModel = UNStickerView.ImageStickerViewModel(image: image!)
            // 添加到贴纸集合中
            self.stickerViews.append(sticker)
    
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UNContentViewController: UINavigationControllerDelegate {
    
}


extension UNContentViewController: UNTouchViewProtocol {
    func UNTouchViewCloseButtonClick(sticker: UNTouchView) {
        print(sticker.tag)
        // 移除父视图
        sticker.removeFromSuperview()
        // 从贴纸集合/数组（贴纸容器）中移除（tag从1000计数，-1000拿到贴纸的下标）
        stickerViews.remove(at: sticker.tag - 1000)
    }
}
