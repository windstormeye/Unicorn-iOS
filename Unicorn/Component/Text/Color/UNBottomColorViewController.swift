//
//  UNBottomColorViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBottomColorViewController: UIViewController {
    var colors: [UIColor]? {didSet{colorCollectionView?.viewColorModels = colors}}
    var colorChange: ((UIColor) -> Void)?
    
    private var colorCollectionView: PJLineCollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        let colorView = EFHSBView(frame: CGRect(x: 0, y: 0, width: 200, height: 250))
        colorView.delegate = self
        view.addSubview(colorView)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 25
        let innerW = CGFloat((200 - 5 * itemW) / 5)
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: innerW / 2, bottom: 0, right: innerW / 2)
        
        let colorCollectionView = PJLineCollectionView(frame: CGRect(x: 0, y: colorView.bottom, width: 200, height: 30), collectionViewLayout: collectionViewLayout)
        colorCollectionView.backgroundColor = .white
        self.colorCollectionView = colorCollectionView
        colorCollectionView.lineType = .color
        colorCollectionView.viewColorModels = colors
        colorCollectionView.cellSelected = { selectedIndex in
            guard self.colors != nil else { return }
            self.colorChange?(self.colors![selectedIndex])
        }
        view.addSubview(colorCollectionView)
    }
}

extension UNBottomColorViewController: EFColorViewDelegate {
    func colorView(_ colorView: EFColorView, didChangeColor color: UIColor) {
        colorChange?(color)
    }
}
