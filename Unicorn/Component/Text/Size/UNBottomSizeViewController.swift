//
//  UNBottomSizeViewController.swift
//  Unicorn
//
//  Created by PJHubs on 2019/4/5.
//  Copyright © 2019 PJHubs. All rights reserved.
//

import UIKit

class UNBottomSizeViewController: UIViewController {

    var size: CGFloat?
    
    @IBOutlet private weak var sizeSlider: UISlider!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    var sizeChange: ((CGFloat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func sizeSliderTouching(_ sender: UISlider) {
        sizeLabel.text = "字体大小：\(Int(sender.value))"
        sizeChange?(CGFloat(ceilf(sender.value)))
    }
    
    private func initView() {
        let v = Bundle.main.loadNibNamed("UNBottomSizeViewController", owner: self, options: nil)?.first as! UIView
        v.frame = view.frame
        
        guard size != nil else { return }
        sizeLabel.text = "字体大小：\(Int(size!))"
        sizeSlider.value = Float(size!)
    }
}
