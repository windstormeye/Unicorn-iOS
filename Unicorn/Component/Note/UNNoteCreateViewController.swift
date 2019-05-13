//
//  UNNoteCreateViewController.swift
//  Unicorn
//
//  Created by YiYi on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNNoteCreateViewController: UIViewController {

    private var noteView = UIView()
    private var noteTitleLabel = UILabel()
    private var bottomCollectionView: UNLineCollectionView?
    private var noteTitleString = "" {
        didSet { noteTitleLabel.text = noteTitleString }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "创建新手帐薄"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        noteView.frame = CGRect(x: view.width * 0.15, y: navigationHeight + 20, width: view.width * 0.7, height: view.height * 0.6)
        noteView.backgroundColor = .red
        noteView.layer.cornerRadius = 10
        view.addSubview(noteView)
        
        noteTitleLabel.frame = CGRect(x: 0, y: 0, width: noteView.width, height: 20)
        view.addSubview(noteTitleLabel)
        noteTitleLabel.text = "封面标题"
        noteTitleLabel.textColor = .white
        noteTitleLabel.center = noteView.center
        noteTitleLabel.textAlignment = .center
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        var itemCount = CGFloat(2)
        let itemW = view.width / itemCount
        if itemCount > 5 { itemCount = CGFloat(5) }
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        
        let collectionView = UNLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .darkGray
        collectionView.viewModels = ["标题", "颜色"]
        bottomCollectionView = collectionView
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
            case 0:
                let alertController = UIAlertController(title: "请输入手帐薄标题",
                                                        message: nil,
                                                        preferredStyle: .alert)
                let ok = UIAlertAction(title: "确定", style: .default, handler: { _ in
                    self.noteTitleString = alertController.textFields![0].text ?? ""
                })
                
                alertController.addTextField(configurationHandler: {
                    $0.placeholder = "手帐标题"
                })
                alertController.addAction(ok)
                
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
        
        noteView.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: nil)
        let colorString = "\(red),\(green),\(blue)"
        
        let viewModel = Note.ViewModel(coverTitle: noteTitleString, coverColor: colorString)
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
            
            return colorPopover
        }
    }
}


extension UNNoteCreateViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
