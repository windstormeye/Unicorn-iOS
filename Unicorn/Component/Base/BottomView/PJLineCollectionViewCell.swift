//
//  PJLineCollectionViewCell.swift
//  WWDC19
//
//  Created by PJHubs on 2019/3/16.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class PJLineCollectionViewCell: UICollectionViewCell {
    var viewModel = "" {didSet { setViewModel()}}
    var viewColorModel: UIColor? {didSet{backgroundColor = viewColorModel}}
    var image: UIImage? { didSet{iconImageView?.image = image }}
    var type: PJLineCollectionView.LineType = .text {didSet{setType()}}
    
    private var tipsLabel: UILabel?
    private var iconImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        let tipLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        tipLabel.text = viewModel
        tipLabel.textAlignment = .center
        tipLabel.textColor = .white
        self.tipsLabel = tipLabel
        addSubview(tipLabel)
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        addSubview(iconImageView)
        self.iconImageView = iconImageView
        iconImageView.contentMode = .scaleAspectFit
    }
    
    private func setViewModel() {
        tipsLabel!.text = viewModel
    }
    
    private func setType() {
        switch type {
        case .text:
            tipsLabel?.isHidden = false
            iconImageView?.isHidden = true
        case .color:
            tipsLabel?.isHidden = true
            iconImageView?.isHidden = true
            backgroundColor = viewColorModel
            layer.cornerRadius = width / 2
            layer.borderColor = UIColor.rgb(220, 220, 220).cgColor
            layer.borderWidth = 1
            
        case .icon:
            iconImageView?.isHidden = false
            iconImageView?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }
    }
}
