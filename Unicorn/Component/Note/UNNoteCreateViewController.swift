//
//  UNNoteCreateViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

// 手帐本创建
class UNNoteCreateViewController: UIViewController {

    private var noteView = UIView()
    // 手帐本 标题 标签（中间的名称）
    private var noteTitleLabel = UILabel()
    // 底部 集合视图
    private var bottomCollectionView: UNLineCollectionView?
    // 设置手帐名称
    private var noteTitleString = "新的手帐本" {
        didSet { noteTitleLabel.text = noteTitleString }
    }
    
    // 页面加载完了
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        // 导航项
        navigationItem.title = "创建新手帐薄"
        view.backgroundColor = .white
        // 导航右侧按钮-“Done” （导航栏按钮项）
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // 手帐本 位置
        noteView.frame = CGRect(x: view.width * 0.15, y: navigationHeight + 20, width: view.width * 0.7, height: view.height * 0.6)
        noteView.backgroundColor = .red
        noteView.layer.cornerRadius = 10
        view.addSubview(noteView)
        
        // 手帐本名称（本子中间位置）
        noteTitleLabel.frame = CGRect(x: 0, y: 0, width: noteView.width, height: 20)
        view.addSubview(noteTitleLabel)
        noteTitleLabel.text = noteTitleString
        noteTitleLabel.textColor = .white
        noteTitleLabel.center = noteView.center
        noteTitleLabel.textAlignment = .center
        
        // 集合视图布局 = 流布局
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let itemW = view.width / CGFloat(2)
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        // 最小项间距
        collectionViewLayout.minimumInteritemSpacing = 10
        // 滚动方向 水平
        collectionViewLayout.scrollDirection = .horizontal
        // 底部 集合视图
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .darkGray
        collectionView.viewModels = ["标题", "颜色"]
        bottomCollectionView = collectionView
        view.addSubview(collectionView)
        
        // cell被选中之后
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
            // 选中“标题”
            case 0:
                // 弹出提示框，message正文，preferredStyle弹窗样式
                let alertController = UIAlertController(title: "请输入手帐薄标题",
                                                        message: nil,
                                                        preferredStyle: .alert)
                let ok = UIAlertAction(title: "确定", style: .default, handler: { _ in
                    // 传数据给
                    self.noteTitleString = alertController.textFields![0].text ?? ""
                })
                // 输入框提示符
                alertController.addTextField(configurationHandler: {
                    $0.placeholder = self.noteTitleString
                })
                alertController.addAction(ok)
                // 从底部弹出
                self.present(alertController, animated: true, completion: nil)
                
            case 1: self.present(self.colorBottomView,
                                 animated: true,
                                 completion: nil)
            default: break
            }
        }
    }
    
    @objc
    private func done() {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        // 取地址 颜色，要存进后端
        noteView.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let colorString = "\(red),\(green),\(blue)"
        // colorString封面颜色拼接为字符串，传出coverColor
        let viewModel = Note.ViewModel(coverTitle: noteTitleString, coverColor: colorString)
        // Note creat里拿到viewModel，也就是coverColor拼接好的字符串 等
        Note.shared.create(viewModel: viewModel, compalteHandler: {
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }) {
            print($0)
        }
    }
    
    /// 颜色
    private var colorBottomView: UNBottomColorViewController {
        get {
            let colorPopover = UNBottomColorViewController()
            colorPopover.colors = [.red, .black, .gray, .green, .darkGray]
            colorPopover.currentColor = self.noteView.backgroundColor
            colorPopover.preferredContentSize = CGSize(width: 200, height: 280)
            colorPopover.modalPresentationStyle = .popover
            
            let colorPopoverPVC = colorPopover.popoverPresentationController
            colorPopoverPVC?.sourceView = self.bottomCollectionView
            colorPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[1], y: 0, width: 0, height: 0)
            colorPopoverPVC?.permittedArrowDirections = .down
            colorPopoverPVC?.delegate = self
            colorPopoverPVC?.backgroundColor = .white
            
            colorPopover.colorChange = { color in
                self.noteView.backgroundColor = color
            }
            colorPopover.bottomColorChange = {
                self.noteView.backgroundColor = $0
            }
            
            return colorPopover
        }
    }
}


extension UNNoteCreateViewController: UIPopoverPresentationControllerDelegate {
    // 自适应
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
