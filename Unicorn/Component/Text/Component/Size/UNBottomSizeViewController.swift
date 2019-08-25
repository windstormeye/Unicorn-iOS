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
    var maxSize: CGFloat?
    var minSize: CGFloat?
    
    // xib画出气泡弹窗样式 UISlider滑动条为【大小】的调节样式；
    @IBOutlet weak var sizeSlider: UISlider!
    // UILabel 调节下方的文字（字号的数字）
    @IBOutlet private weak var sizeLabel: UILabel!
    
    // 反向闭包传值（用来给父视图传 文字大小的数值）
    var sizeChange: ((CGFloat) -> Void)?
    
    // 重载父视图
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    // 根据调节 改变数值（xib可设置，给横线调节组件sender 绑定value change状态）
    // 改变数值时 调用
    @IBAction func sizeSliderTouching(_ sender: UISlider) {
        // 获取“横线”sender的值（取到UISlider的值）
        sizeLabel.text = "大小：\(Int(sender.value))"
        // sizeChange闭包，反向传值。获取到值传出
        // Float类型，需要整数，所以用ceilf向上取整。例如：23.111 -> 24
        sizeChange?(CGFloat(ceilf(sender.value)))
    }
    
    // xib要初始化好给view，而storyboard可以直接读出来用
    // 初始化 气泡的view。
    private func initView() {
        // UNBottomSizeViewController.xib 初始化好给view
        let v = Bundle.main.loadNibNamed("UNBottomSizeViewController", owner: self, options: nil)?.first as! UIView
        // 父视图view的宽和高给v
        v.frame = view.frame
        
        // 可以设置Slider字号数值滑动条的最大值最小值（也可用xib写）
        if maxSize != nil {
            sizeSlider.maximumValue = Float(maxSize!)
        }

        if minSize != nil {
            sizeSlider.minimumValue = Float(minSize!)
        }
        
        // size必须有值
        if size != nil {
            // 读当前大小
            sizeLabel.text = "大小：\(Int(size!))"
            // 保证下一次点开时还是之前选择的文字大小
            sizeSlider.value = Float(size!)
        }
    }
}
