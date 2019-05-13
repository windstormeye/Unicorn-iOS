//
//  UNShowContentCollectionView.swift
//  WWDC19
//
//  Created by YiYi on 2019/3/16.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

class UNLineCollectionView: UICollectionView {
    private let cellIdentifier = "UNLineCollectionViewCell"
    
    var viewDelegate: UNLineCollectionViewDelegate?
    var viewModels: [String]? {didSet{ reloadData()}}
    var viewColorModels: [UIColor]? {didSet{ reloadData()}}
    var cellCenterXs = [CGFloat]()
    var lineType: LineType = .text
    var iconTitle = "home-"
    var iconCount = 5
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
        
        register(UNLineCollectionViewCell.self,
                 forCellWithReuseIdentifier: "UNLineCollectionViewCell")
    }
}

extension UNLineCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        cellSelected?(indexPath.row)
    }
}

extension UNLineCollectionView: UICollectionViewDataSource {
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
            return iconCount
        case .cover:
            guard let viewColorModels = viewColorModels else { return 0 }
            return viewColorModels.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UNLineCollectionViewCell", for: indexPath) as! UNLineCollectionViewCell
        cell.type = lineType
        
        switch lineType {
        case .text:
            cell.viewModel = viewModels![indexPath.row]
        case .color:
            cell.viewColorModel = viewColorModels![indexPath.row]
        case .icon:
            cell.image = UIImage(named: iconTitle + "\(indexPath.row)")
        case .cover:
            cell.viewColorModel = viewColorModels![indexPath.row]
            cell.viewModel = viewModels![indexPath.row]
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowOpacity = 0.4
        }
        cellCenterXs.append(cell.center.x)
        
        return cell
    }
}

extension UNLineCollectionView {
    enum LineType {
        case text
        case color
        case icon
        case cover
    }
}

protocol UNLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int)
}

extension UNLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {}
}

