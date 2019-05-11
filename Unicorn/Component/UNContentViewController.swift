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
    var bookId: Int?
    
    private var stickerViews = [UNSticerView]()
    private var bottomCollectionView: PJLineCollectionView?
    private var itemColors = [UIColor.black, UIColor.white, UIColor.red, UIColor.blue, UIColor.green]
    private var imagePicker = UIImagePickerController()
    private var bgImageView = UIImageView()
    private var stickerComponentView = UNStickerComponentView()
    private var stickerTag = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        // 画笔
        let brushView = UNBrushView(frame: CGRect(x: 0, y: topSafeAreaHeight, width: view.width, height: view.height - bottomSafeAreaHeight - 64 - topSafeAreaHeight))
        brushView.isHidden = true
        view.addSubview(brushView)
        
        // 背景图片
        bgImageView.frame = CGRect(x: 0, y: brushView.y, width: view.width, height: brushView.height)
        view.addSubview(bgImageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenView))
        bgImageView.isUserInteractionEnabled = true
        bgImageView.addGestureRecognizer(tap)
        
        stickerComponentView = UNStickerComponentView(frame: CGRect(x: 0, y: view.height, width: view.width, height: 200))
        stickerComponentView.isHidden = true
        view.addSubview(stickerComponentView)
        stickerComponentView.sticker = {
            $0.viewDelegate = self
            $0.center = self.view.center
            $0.tag = self.stickerTag
            self.stickerTag += 1
            self.view.addSubview($0)
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
        
        let collectionView = PJLineCollectionView(frame: CGRect(x: 0, y: view.height - bottomSafeAreaHeight - 64, width: view.width, height: 64 + bottomSafeAreaHeight), collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = UIColor(red: 54/255, green: 149/255, blue: 1, alpha: 1)
        self.bottomCollectionView = collectionView
        collectionView.lineType = .icon
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in
            switch cellIndex {
            case 0:
                self.stickerComponentView.isHidden = true
                
                brushView.isHidden = true
                self.bgImageView.image = brushView.drawImage()
                
                self.present(self.colorBottomView, animated: true, completion: nil)
            
            case 1:
                brushView.isHidden = true
                self.bgImageView.image = brushView.drawImage()
                
                self.stickerComponentView.isHidden = false
                UIView.animate(withDuration: 0.25, animations: {
                    self.stickerComponentView.bottom = self.bottomCollectionView!.y
                })
                
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
                
            case 3:
                self.stickerComponentView.isHidden = true
                
                brushView.isHidden = true
                self.bgImageView.image = brushView.drawImage()
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
                
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
    
    @objc
    private func done() {
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.width, height: view.height - bottomCollectionView!.height), false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let bgImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        saveImage(image: bgImage!)
        
//        var sIndex = 0
//        for sticker in stickerViews {
//            if sticker.id != nil {
//                let viewModel = Sticker.ViewModel(id: sticker.id!,
//                                                  x: sticker.x,
//                                                  y: sticker.y,
//                                                  w: sticker.width,
//                                                  h: sticker.height,
//                                                  rotate: sticker.rotate,
//                                                  type: sticker.stickerType.rawValue,
//                                                  data: nil,
//                                                  bookId: bookId!,
//                                                  defaultIndex: sticker.defaultIndex)
//                Sticker.shared.update(viewModel: viewModel, complateHandler: {
//                    sIndex += 1
//                    if sIndex == self.stickerViews.count {
//                        DispatchQueue.main.async {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }) {
//                    print($0)
//                }
//            } else {
//                let viewModel = Sticker.ViewModel(id: nil,
//                                                  x: sticker.x,
//                                                  y: sticker.y,
//                                                  w: sticker.width,
//                                                  h: sticker.height,
//                                                  rotate: sticker.rotate,
//                                                  type: sticker.stickerType.rawValue,
//                                                  data: nil,
//                                                  bookId: bookId!,
//                                                  defaultIndex: sticker.defaultIndex)
//                Sticker.shared.create(viewModel: viewModel, complateHandler: {
//                    sIndex += 1
//                    if sIndex == self.stickerViews.count {
//                        DispatchQueue.main.async {
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }) {
//                    print($0)
//                }
//            }
//        }
    }
    
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
    
    /// 颜色
    private var colorBottomView: UNBottomColorViewController {
        get {
            let colorPopover = UNBottomColorViewController()
            colorPopover.colors = itemColors
            colorPopover.currentColor = self.view.backgroundColor!
            colorPopover.preferredContentSize = CGSize(width: 200, height: 280)
            colorPopover.modalPresentationStyle = .popover
            
            let colorPopoverPVC = colorPopover.popoverPresentationController
            colorPopoverPVC?.sourceView = self.bottomCollectionView
            colorPopoverPVC?.sourceRect = CGRect(x: bottomCollectionView!.cellCenterXs[0], y: 0, width: 0, height: 0)
            colorPopoverPVC?.permittedArrowDirections = .down
            colorPopoverPVC?.delegate = self
            colorPopoverPVC?.backgroundColor = .white
            
            colorPopover.colorChange = { color in
                self.view.backgroundColor = color
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
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if image != nil {
            let wh = image!.size.width / image!.size.height
            let sticker = UNSticerView(frame: CGRect(x: 150, y: 150, width: 100, height: 100 * wh))
            self.view.addSubview(sticker)
            sticker.imgViewModel = UNSticerView.ImageStickerViewModel(image: image!)
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
