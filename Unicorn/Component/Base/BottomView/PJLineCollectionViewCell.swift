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
    
    private let fonts = ["PingFang SC", ""]
    
    private var tipsLabel: UILabel?
    
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
    }
    
    private func setViewModel() {
        tipsLabel!.text = viewModel
    }
}
