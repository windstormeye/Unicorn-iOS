//
//  UNContentViewController.swift
//  Unicorn
//
//  Created by YiYi on 2019/3/25.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit
import Alamofire

class UNContentViewController: UIViewController {
    /// 当前编辑页面所属的手帐
    var bookId: Int?
    /// 贴纸集合
    private var stickerViews = [UNSticerView]()
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
        didSet { self.changeGradientLayer(colors: bgColors) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // 设置背景颜色
        view.backgroundColor = .white
        // 设置导航栏右按钮
        navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)), UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(share))]
        
        // 初始化渐变层
        self.view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = self.view.bounds
        // 从左下角
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        // 到右上角 进行渲染
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        
        // 画笔
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
        
        // 贴纸容器
        stickerComponentView = UNStickerComponentView(frame: CGRect(x: 0, y: view.height, width: view.width, height: 200))
        // 先隐藏
        stickerComponentView.isHidden = true
        view.addSubview(stickerComponentView)
        // 选择了贴纸后，通过闭包带出选择的贴纸
        stickerComponentView.sticker = {
            $0.viewDelegate = self
            // 父视图居中
            $0.center = self.view.center
            $0.tag = self.stickerTag
            self.stickerTag += 1
            self.view.addSubview($0)
            // 添加到贴纸集合中
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
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64 + bottomSafeAreaHeight), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor(red: 54/255, green: 149/255, blue: 1, alpha: 1)
        self.bottomCollectionView = collectionView
        collectionView.lineType = .icon
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
                // 背景
                case 0:
                    self.stickerComponentView.isHidden = true
                    
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    
                    self.present(self.colorBottomView, animated: true, completion: nil)
                // 贴纸
                case 1:
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    
                    self.stickerComponentView.isHidden = false
                    UIView.animate(withDuration: 0.25, animations: {
                        self.stickerComponentView.bottom = self.bottomCollectionView!.y
                    })
                // 文字
                case 2:
                    self.stickerComponentView.isHidden = true
                    
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    
                    let vc = UNTextViewController()
                    self.present(vc, animated: true, completion: nil)
                    vc.complateHandler = { viewModel in
                        let stickerLabel = UNSticerView(frame: CGRect(x: 150, y: 150, width: 100, height: 100))
                        self.view.addSubview(stickerLabel)
                        stickerLabel.textViewModel = viewModel
                        self.stickerViews.append(stickerLabel)
                    }
                // 照片
                case 3:
                    self.stickerComponentView.isHidden = true
                    
                    brushView.isHidden = true
                    self.bgImageView.image = brushView.drawImage()
                    
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .photoLibrary
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                // 画笔
                case 4:
                    self.stickerComponentView.isHidden = true
                    
                    brushView.isHidden = false
                    self.bgImageView.image = nil
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
        
        let urlString = "http://localhost:8080/api/sticker/upload?bookId=\(bookId!)"
        // 压缩比例 0.7（有损压缩）
        let imgData = imageToSave.jpegData(compressionQuality: 0.7)!
        let imageName = "sticker.png"
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file", fileName: imageName, mimeType: "image/png") }, to:urlString) {
                
                switch $0 {
                case .success(let upload, _, _):
                    // 图片上传进度
                    upload.uploadProgress(closure: { (progress) in
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })

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
        
        gradientLayer.locations = numbers.reversed()
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
        // 开启某个大小的上下文空间
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.width, height: view.height - bottomCollectionView!.height), false, UIScreen.main.scale)
        // 把 view.layer 渲染进当前打开的上下文空间
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        // 从上下文空间中获取 UIImage
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭
        UIGraphicsEndImageContext()
        
        
        
        let items = [ bgImage ]
        let toVC = UIActivityViewController(activityItems: items as [Any],
                                            applicationActivities: nil)
        present(toVC, animated: true, completion: nil)
        
        
        toVC.completionWithItemsHandler = {(_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ activityError: Error?) -> Void in
            if completed {
                print("分享成功")
            }
        }
    }
    
    /// 颜色
    private var colorBottomView: UNBottomColorViewController {
        get {
            let colorPopover = UNBottomColorViewController()
            colorPopover.colors = [UIColor.black, UIColor.white, UIColor.red, UIColor.blue, UIColor.green]
            colorPopover.currentColor = self.view.backgroundColor!
            colorPopover.preferredContentSize = CGSize(width: 200, height: 280)
            colorPopover.modalPresentationStyle = .popover
            
            let colorPopoverPVC = colorPopover.popoverPresentationController
            colorPopoverPVC?.sourceView = self.bottomCollectionView
            colorPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[0], y: 0, width: 0, height: 0)
            colorPopoverPVC?.permittedArrowDirections = .down
            colorPopoverPVC?.delegate = self
            colorPopoverPVC?.backgroundColor = .white
            
            // 颜色轮盘
            colorPopover.colorChange = {
                self.view.backgroundColor = $0
                self.bgColors.removeAll()
            }
            // 底部颜色栏
            colorPopover.bottomColorChange = {
                self.bgColors.append($0)
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
        
        // 判断是否选中，来决定是否显示“选中框”
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


extension UNContentViewController: UIImagePickerControllerDelegate {
    /// 从图片选择器中获取选择到的图片
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 获取到编辑后的图片
        let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if image != nil {
            let wh = image!.size.width / image!.size.height
            let sticker = UNSticerView(frame: CGRect(x: 150, y: 150, width: 100, height: 100 * wh))
            self.view.addSubview(sticker)
            sticker.imgViewModel = UNSticerView.ImageStickerViewModel(image: image!)
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
        sticker.removeFromSuperview()
        stickerViews.remove(at: sticker.tag - 1000)
    }
}
