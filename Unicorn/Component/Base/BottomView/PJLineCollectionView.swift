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
    var viewColorModels: [UIColor]? {didSet{ reloadData()}}
    var cellCenterXs = [CGFloat]()
    var lineType: LineType = .text
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
        switch lineType {
        case .text:
            guard let viewModels = viewModels else { return 0 }
            return viewModels.count
        case .color:
            guard let viewColorModels = viewColorModels else { return 0 }
            return viewColorModels.count
        case .icon:
            return 4
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PJLineCollectionViewCell", for: indexPath) as! PJLineCollectionViewCell
        cell.type = lineType
        
        switch lineType {
        case .text:
            cell.viewModel = viewModels![indexPath.row]
        case .color:
            cell.viewColorModel = viewColorModels![indexPath.row]
        case .icon:
            cell.image = UIImage(named: "home-\(indexPath.row)")
        }
        cellCenterXs.append(cell.center.x)
        
        return cell
    }
}

extension PJLineCollectionView {
    enum LineType {
        case text
        case color
        case icon
    }
}

protocol PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int)
}

extension PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {}
}

