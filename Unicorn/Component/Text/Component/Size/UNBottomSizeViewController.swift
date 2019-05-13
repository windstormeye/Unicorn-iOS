//
//  UNBottomSizeViewController.swift
//  Unicorn
//
//  Created by YiYi on 2019/4/5.
//  Copyright © 2019 YiYi. All rights reserved.
//

import UIKit

class UNBottomSizeViewController: UIViewController {

    var size: CGFloat?
    var maxSize: CGFloat?
    var minSize: CGFloat?
    
    @IBOutlet weak var sizeSlider: UISlider!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    var sizeChange: ((CGFloat) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    @IBAction func sizeSliderTouching(_ sender: UISlider) {
        sizeLabel.text = "大小：\(Int(sender.value))"
        sizeChange?(CGFloat(ceilf(sender.value)))
    }
    
    private func initView() {
        let v = Bundle.main.loadNibNamed("UNBottomSizeViewController", owner: self, options: nil)?.first as! UIView
        v.frame = view.frame
        
        if maxSize != nil {
            sizeSlider.maximumValue = Float(maxSize!)
        }
        
        if minSize != nil {
            sizeSlider.minimumValue = Float(minSize!)
        }
        
        if size != nil {
            sizeLabel.text = "大小：\(Int(size!))"
            sizeSlider.value = Float(size!)
        }
    }
}
