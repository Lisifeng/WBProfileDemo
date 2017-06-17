//
//  SegmentView.swift
//  WBProfileDemo
//
//  Created by 唐标 on 2017/6/14.
//  Copyright © 2017年 jackTang. All rights reserved.
//

import UIKit

//MARK: -- property init
class SegmentView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpSegmentController()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        self.setUpSegmentController()
    }
    
    public var segmentedControl: HMSegmentedControl!
}

//MARK: -- private method
extension SegmentView {
    
    func setUpSegmentController() {
        
        backgroundColor = UIColor.white
        
        segmentedControl = HMSegmentedControl()
        segmentedControl.sectionTitles = ["主页", "微博", "视频", "头条"]
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorColor = UIColor.red
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, -4, 20);
        segmentedControl.selectedTitleTextAttributes = [ NSForegroundColorAttributeName : UIColor.red,
                                                         NSFontAttributeName : UIFont.systemFont(ofSize: 15)]
        segmentedControl.titleTextAttributes = [ NSForegroundColorAttributeName : UIColor.black,
                                                 NSFontAttributeName : UIFont.systemFont(ofSize: 15)]
        segmentedControl.frame = self.bounds
        self.addSubview(segmentedControl)
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        lineView.frame = CGRect(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 1)
        self.addSubview(lineView)
    }
    
}
