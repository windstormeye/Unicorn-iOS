//
//  UNNoteViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/5/10.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNNoteViewController: UIViewController {

    private var coverIds = [Int]()
    private var collectionView: PJLineCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        navigationItem.title = "Unicorn 世界上最好用的手帐"
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "profile"), style: .plain, target: self, action: #selector(profile))
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = view.width * 0.4
        let itemCount = CGFloat(2)
        let innerW = (view.width - itemCount * itemW) / itemCount
        collectionViewLayout.itemSize = CGSize(width: itemW, height: itemW * 1.7)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(top: innerW / 2, left: innerW / 2, bottom: 20, right: innerW / 2)
        
        let collectionView = PJLineCollectionView(frame: CGRect(x: 0, y: navigationHeight, width: view.width, height: view.height - navigationHeight - bottomSafeAreaHeight), collectionViewLayout: collectionViewLayout)
        self.collectionView = collectionView
        collectionView.backgroundColor = .clear
        collectionView.lineType = .cover
        view.addSubview(collectionView)
        
        collectionView.cellSelected = { cellIndex in

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.shared.viewModel.token == nil {
            let sb = UIStoryboard(name: "UNUserLoginViewController", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "UNUserLoginViewController")
            present(vc, animated: true, completion: nil)
        }
        
        Note.shared.get(compalteHandler: {
            var titles = [String]()
            var colors = [UIColor]()
            
            for d: Dictionary in $0 {
                titles.append(d["coverTitle"] as! String)
                self.coverIds.append(d["id"] as! Int)
                
                let colorString = d["coverColor"] as! String
                let colorSplitString = colorString.split(separator: ",")
                let color = UIColor.rgb(CGFloat(Double(String(colorSplitString[0]))!) * 255, CGFloat(Double(String(colorSplitString[1]))!) * 255, CGFloat(Double(String(colorSplitString[2]))!) * 255)
                colors.append(color)
                
                DispatchQueue.main.async {
                    self.collectionView!.viewColorModels = colors
                    self.collectionView!.viewModels = titles
                }
            }
        }) {
            print($0)
        }
    }
    
    @objc
    private func addNote() {
        let vc = UNNoteCreateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func profile() {
        
    }
}
