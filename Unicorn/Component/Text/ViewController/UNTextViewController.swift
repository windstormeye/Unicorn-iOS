//
//  UNTextViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTextViewController: UIViewController {
    var complateHandler: ((UNStickerView.TextStickerViewModel) -> Void)?
    
    private var textView = UITextView()
    private var bottomCollectionView: UNLineCollectionView?
    private var itemImageNames = ["字体", "大小", "颜色"]
    private var itemColors = [UIColor.black, UIColor.white, UIColor.red, UIColor.blue, UIColor.green]
    private var textFonts = ["FZLuXunTiS-R-GB",
                             "FZQingFangSongS",
                             "FZZJ-FOJW",
                             "FZZJ-HTKSJW",
                             "FZZJ-MSMLJW",
                             "FZZJ-ZJJYBKTJW"]
    
    private let topViewBottom = topSafeAreaHeight + 10 + 30
    private var viewModel: UNStickerView.TextStickerViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // 编辑文字界面
        view.backgroundColor = UIColor(red: 1, green: 240/255, blue: 209/255, alpha: 1)
        // 左上角返回按钮
        let backButton = UIButton(frame: CGRect(x: 15, y: statusBarHeight + 10, width: 30, height: 30))
        view.addSubview(backButton)
        backButton.setTitleColor(.darkGray, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.setTitle("←", for: .normal)
        // 返回按钮触发的动作。调用back的backButtonClick使视图消失
        backButton.addTarget(self, action: .back, for: .touchUpInside)

        let doneButton = UIButton(frame: CGRect(x: screenWidth - 30 - 15, y: backButton.top, width: backButton.width, height: backButton.height))
        view.addSubview(doneButton)
        doneButton.titleLabel?.font = backButton.titleLabel?.font
        doneButton.setTitle("✓", for: .normal)
        doneButton.setTitleColor(.darkGray, for: .normal)
        // 触发动作。在done事件里的doneButtonClick 
        doneButton.addTarget(self, action: .done, for: .touchUpInside)
        
        // 设置textView各种UI属性
        // 注：textView本身无需设置就可输入内容
        textView.frame = CGRect(x: 15, y: backButton.bottom + 10, width: view.width - 30, height: 300)
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textView.becomeFirstResponder()//调键盘/可供输入
        // 光标颜色
        textView.tintColor = .darkGray
        textView.textColor = .darkGray
        // 键盘外观
        textView.keyboardAppearance = .dark
        view.addSubview(textView)

        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 50
        var itemCount = CGFloat(itemImageNames.count)
        if itemCount > 5 { itemCount = CGFloat(5) }
        let innerW = (screenWidth - itemCount * 50) / itemCount
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        // 距离四周的间距
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .darkGray
        self.bottomCollectionView = collectionView
        collectionView.viewModels = itemImageNames
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
            case 0: self.present(self.fontBottomView,
                                 animated: true,
                                 completion: nil)
            case 1: self.present(self.sizeBottomView,
                                 animated: true,
                                 completion: nil)
            case 2: self.present(self.colorBottomView,
                                 animated: true,
                                 completion: nil)
            default: break
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: .keyboardFrame, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc
    fileprivate func keyBoardFrameChange(_ notification: Notification){
        let info = notification.userInfo
        let kbRect = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offsetY = kbRect.origin.y - view.height
        UIView.animate(withDuration: 0.3) {
            if offsetY == 0 {
                self.bottomCollectionView!.transform = CGAffineTransform(translationX: 0, y: 0)
            }else{
                self.bottomCollectionView!.transform = CGAffineTransform(translationX: 0, y: offsetY)
                self.textView.height = self.view.height - abs(offsetY) - self.topViewBottom - 45 - self.bottomCollectionView!.height
            }
        }
    }
    
    // 【完成】按钮
    @objc
    fileprivate func doneButtonClick() {
        // 贴纸视图中的 文字贴纸视图模型（TextStickerViewModel结构体中含有属性）
        let viewModel = UNStickerView.TextStickerViewModel(text: textView.text!, textColor: textView.textColor!, textFont: textView.font!)
        // 把建好的viewModel传入
        // 可把viewModel返给ContentViewController。使文字变为文字贴纸
        complateHandler?(viewModel)
        // 视图消失
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    fileprivate func backButtonClick() {
        // 从上往下消失
        dismiss(animated: true, completion: nil)
    }
    
    /// 字体
    private var fontBottomView: UNBottomFontsTableViewController {
        get {
            let sb = UIStoryboard(name: "UNBottomFontsTableViewController", bundle: nil)
            // 从Storyboard里面加载ViewController
            let fontPopover = sb.instantiateViewController(withIdentifier: "UNBottomFontsTableViewController") as! UNBottomFontsTableViewController;

            // CGSize设置宽高
            fontPopover.preferredContentSize = CGSize(width: 150, height: 250)
            // 弹出框样式
            fontPopover.modalPresentationStyle = .popover
            // 字体集数据源（把textFonts里字体传入）
            fontPopover.fonts = self.textFonts
            
            // 获取“泡”样式
            let fontPopoverPVC = fontPopover.popoverPresentationController
            // 源视图 = 底部集合视图
            fontPopoverPVC?.sourceView = self.bottomCollectionView
            //弹窗位于源视图的位置，气泡位置x：是cell的中心点位置。用cellCenterXs数组存中心点坐标
            fontPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[0], y: 0, width: 0, height: 0)
            // 设置（气泡）箭头方向
            fontPopoverPVC?.permittedArrowDirections = .down
            // 设置操作（确保气泡能弹出）
            fontPopoverPVC?.delegate = self
            fontPopoverPVC?.backgroundColor = .white
            
            // 反向传值（用来记录点击以后的选择）调用cellSelected闭包
            fontPopover.cellSelected = { selectedIndex in
                // 文本框的字体=根据索引从数组取字体名称，字号-获取当前字号pointSize
                // 所输入的文字 字体 = 从数组里获取的字体
                self.textView.font = UIFont(name: self.textFonts[selectedIndex], size: self.textView.font!.pointSize)
                // 使气泡弹窗消失（用户选中字体后，选框消失）
                fontPopover.dismiss(animated: true, completion: nil)
            }
            
            // 创建完成 返回气泡弹窗
            return fontPopover
        }
    }
    
    /// 大小 字号
    private var sizeBottomView: UNBottomSizeViewController {
        get {
            let sizePopover = UNBottomSizeViewController()
            sizePopover.size = self.textView.font?.pointSize
            sizePopover.preferredContentSize = CGSize(width: 200, height: 100)
            // 弹出框样式
            sizePopover.modalPresentationStyle = .popover
            
            // 获取“泡”样式
            let sizePopoverPVC = sizePopover.popoverPresentationController
            // 源视图 = 底部集合视图
            sizePopoverPVC?.sourceView = self.bottomCollectionView
            //弹窗位于源视图的位置，气泡位置x：是cell的中心点位置。用cellCenterXs数组存中心点坐标
            sizePopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[1], y: 0, width: 0, height: 0)
            // 设置（气泡）箭头方向
            sizePopoverPVC?.permittedArrowDirections = .down
            // 操作
            sizePopoverPVC?.delegate = self
            sizePopoverPVC?.backgroundColor = .white
            
            // 字号大小改变
            // sizeChange闭包反向传值。SizeViewController里改变数值时传值
            sizePopover.sizeChange = { size in
                // 获取当前字体（字体不动），修改字号 获取字号
                self.textView.font = UIFont(name: self.textView.font!.familyName, size: size)
            }
            
            return sizePopover
        }
    }
    
    /// 颜色
    private var colorBottomView: UNBottomColorViewController {
        get {
            // 整个“颜色”气泡弹窗
            let colorPopover = UNBottomColorViewController()
            // itemColors 几个固定颜色的数组
            colorPopover.colors = itemColors
            // 当前颜色 （从文本直接取）
            colorPopover.currentColor = self.textView.textColor
            colorPopover.preferredContentSize = CGSize(width: 200, height: 280)
            // 弹出框样式
            colorPopover.modalPresentationStyle = .popover
            
            // 获取“泡”样式
            let colorPopoverPVC = colorPopover.popoverPresentationController
            // 源视图 = 底部集合视图
            colorPopoverPVC?.sourceView = self.bottomCollectionView
            //弹窗位于源视图的位置，气泡位置x：是cell的中心点位置。用cellCenterXs数组存中心点坐标
            colorPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[2], y: 0, width: 0, height: 0)
            // 设置（气泡）箭头方向
            colorPopoverPVC?.permittedArrowDirections = .down
            // 操作
            colorPopoverPVC?.delegate = self
            colorPopoverPVC?.backgroundColor = .white
            colorPopover.colorChange = {
                self.textView.textColor = $0
            }
            // 底部颜色栏
            colorPopover.bottomColorChange = {
                self.textView.textColor = $0
            }
            
            return colorPopover
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

private extension Selector {
    static let keyboardFrame = #selector(UNTextViewController.keyBoardFrameChange(_:))
    static let back = #selector(UNTextViewController.backButtonClick)
    static let done = #selector(UNTextViewController.doneButtonClick)
}

extension UNTextViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
