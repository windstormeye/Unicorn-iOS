//
//  PJShowContentCollectionView.swift
//  WWDC19
//
//  Created by PJHubs on 2019/3/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJLineCollectionView: UICollectionView {
    private let cellIdentifier = "PJLineCollectionViewCell"
    
    var viewDelegate: PJLineCollectionViewDelegate?
    var viewModels: [String]? {didSet{ reloadData()}}
    var cellCenterXs = [CGFloat]()
    
    var cellSelected: ((Int) -> Void)?
    
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: layout)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .darkGray
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
        delegate = self
        dataSource = self
        
        register(PJLineCollectionViewCell.self,
                 forCellWithReuseIdentifier: "PJLineCollectionViewCell")
    }
}

extension PJLineCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
}

extension PJLineCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PJLineCollectionViewCell", for: indexPath) as! PJLineCollectionViewCell
        cell.viewModel = viewModels![indexPath.row]
        cellCenterXs.append(cell.center.x)
        return cell
    }
}

protocol PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int)
}

extension PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {}
}

