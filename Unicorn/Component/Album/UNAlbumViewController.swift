//
//  UNAlbumViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNAlbumViewController: UIViewController {
    var imageSelected: ((CGFloat, UIImage) -> Void)?
    
    private var itemNames = ["滤镜"]
    private var bottomCollectionView: PJLineCollectionView?
    private var imagePicker = UIImagePickerController()
    private var currentImage = UIImage()
    private var imageView = UIImageView()
    private let topViewBottom = topSafeAreaHeight + 10 + 30
    private var wh: CGFloat = 1
    
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
        doneButton.addTarget(self, action: .done, for: .touchUpInside)
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 50
        var itemCount = CGFloat(itemNames.count)
        if itemCount > 5 { itemCount = CGFloat(5) }
        let innerW = (screenWidth - itemCount * 50) / itemCount
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let collectionView = PJLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .darkGray
        self.bottomCollectionView = collectionView
        collectionView.viewModels = itemNames
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
//            case 0: self.present(self.sizeBottomView,
//                                 animated: true,
//                                 completion: nil)
//            case 1: self.present(self.sizeBottomView,
//                                 animated: true,
//                                 completion: nil)
            default: break
            }
        }
        
        
        imageView = UIImageView(frame: CGRect(x: 10, y: navigationHeight + 10, width: view.width - 20, height: view.height - navigationHeight - 20 - collectionView.height))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        view.addSubview(imageView)
    }
    
    @objc
    fileprivate func doneButtonClick() {
        guard imageView.image != nil else { return }
        imageSelected?(wh, imageView.image!)
        dismiss(animated: true, completion: nil)
    }
}

extension UNAlbumViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if image != nil {
            self.currentImage = image!
            self.imageView.image = image!
            wh = image!.size.width / image!.size.height
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UNAlbumViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension UNAlbumViewController: UINavigationControllerDelegate {
    
}

private extension Selector {
    static let done = #selector(UNAlbumViewController.doneButtonClick)
}
