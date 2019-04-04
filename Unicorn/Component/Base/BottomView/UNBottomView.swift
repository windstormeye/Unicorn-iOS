//
//  UNBottomView.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/3.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBottomView: UIView {
    var itemImageNames = [String]() {didSet {didSetItemImageNames()}}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        backgroundColor = .darkGray
        
        
    }
    
    private func didSetItemImageNames() {
        
    }
}
