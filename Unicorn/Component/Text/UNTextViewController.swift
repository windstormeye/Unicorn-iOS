//
//  UNTextViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/2.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNTextViewController: UIViewController {

    private var textView = UITextView()
    private var bottomCollectionView: PJLineCollectionView?
    private var itemImageNames = ["字体", "大小", "颜色", "背景"]
    private var textFonts = ["FZLuXunTiS-R-GB",
                             "FZQingFangSongS",
                             "FZZJ-FOJW",
                             "FZZJ-HTKSJW",
                             "FZZJ-MSMLJW",
                             "FZZJ-ZJJYBKTJW"]
    
    private let topViewBottom = topSafeAreaHeight + 10 + 30
    private var textViewSize: CGFloat = 22.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        let backButton = UIButton(frame: CGRect(x: 15, y: statusBarHeight + 10, width: 30, height: 30))
        view.addSubview(backButton)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        backButton.setTitle("←", for: .normal)
        
        let doneButton = UIButton(frame: CGRect(x: screenWidth - 30 - 15, y: backButton.top, width: backButton.width, height: backButton.height))
        view.addSubview(doneButton)
        doneButton.titleLabel?.font = backButton.titleLabel?.font
        doneButton.setTitle("✓", for: .normal)
        
        
        textView.frame = CGRect(x: 15, y: backButton.bottom + 10, width: view.width - 30, height: 300)
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        textView.becomeFirstResponder()
        textView.tintColor = .white
        textView.textColor = .white
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
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = PJLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64), collectionViewLayout: collectionViewLayout)
        self.bottomCollectionView = collectionView
        collectionView.viewModels = itemImageNames
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
            case 0: self.present(self.fontBottomView, animated: true, completion: nil)
            case 1: self.present(self.sizeBottomView, animated: true, completion: nil)
            case 2: self.textView.textColor = .red
            case 3: break
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// 字体
    private var fontBottomView: UNBottomFontsTableViewController {
        get {
            let sb = UIStoryboard(name: "UNBottomFontsTableViewController", bundle: nil)
            let fontPopover = sb.instantiateViewController(withIdentifier: "UNBottomFontsTableViewController") as! UNBottomFontsTableViewController;
            fontPopover.preferredContentSize = CGSize(width: 200, height: 250)
            fontPopover.modalPresentationStyle = .popover
            fontPopover.fonts = self.textFonts
            
            let fontPopoverPVC = fontPopover.popoverPresentationController
            fontPopoverPVC?.sourceView = self.bottomCollectionView
            fontPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[0], y: 0, width: 0, height: 0)
            fontPopoverPVC?.permittedArrowDirections = .down
            fontPopoverPVC?.delegate = self
            fontPopoverPVC?.backgroundColor = .white
            
            fontPopover.cellSelected = { selectedIndex in
                self.textView.font = UIFont(name: self.textFonts[selectedIndex], size: 22)
                fontPopover.dismiss(animated: true, completion: nil)
            }
            return fontPopover
        }
    }
    
    /// 大小
    private var sizeBottomView: UNBottomSizeViewController {
        get {
            let sizePopover = UNBottomSizeViewController()
            sizePopover.size = textViewSize
            sizePopover.preferredContentSize = CGSize(width: 200, height: 100)
            sizePopover.modalPresentationStyle = .popover
            
            let sizePopoverPVC = sizePopover.popoverPresentationController
            sizePopoverPVC?.sourceView = self.bottomCollectionView
            sizePopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[1], y: 0, width: 0, height: 0)
            sizePopoverPVC?.permittedArrowDirections = .down
            sizePopoverPVC?.delegate = self
            sizePopoverPVC?.backgroundColor = .white
            
            sizePopover.sizeChange = { size in
                self.textView.font = UIFont(name: self.textView.font!.familyName, size: size)
                self.textViewSize = size
            }
            
            return sizePopover
        }
    }
}

private extension Selector {
    static let keyboardFrame = #selector(UNTextViewController.keyBoardFrameChange(_:))
}

extension UNTextViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
