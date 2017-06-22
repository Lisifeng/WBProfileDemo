//
//  ProfileCellContentView.swift
//  WBProfileDemo
//
//  Created by 唐标 on 2017/6/14.
//  Copyright © 2017年 jackTang. All rights reserved.
//

import UIKit

class ProfileCellContentView: UIView {
    
    fileprivate weak var superController: WBProfileViewController!
    //    左右滚动的scrollView
    public lazy var scrollView: UIScrollView = { [unowned self] _ in
        let scrollView = UIScrollView(frame:self.bounds)
        scrollView.contentSize = CGSize.init(width: kScreeenWidth * 4, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.yellow
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        return scrollView
        }()
    
    public var scrollViewDidScrollBlock: ((Int) -> ())?
    
    convenience init(frame: CGRect, superViewController: WBProfileViewController) {
        self.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.superController = superViewController
        let colorArr = [UIColor.white, UIColor.black, UIColor.yellow, UIColor.darkGray]

        for i in 0...3 {
            let profileSubViewController = ProfileSubTableViewController()
            superViewController.addChildViewController(profileSubViewController)
            
            profileSubViewController.view.frame = CGRect(x: kScreeenWidth * CGFloat(i), y: 0, width: kScreeenWidth, height: self.bounds.size.height)
            profileSubViewController.view.backgroundColor = colorArr[i]
            scrollView.addSubview(profileSubViewController.view)
            profileSubViewController.didMove(toParentViewController: superViewController)
        }
        addSubview(scrollView)
    }
}

//MARK: -- UIScrollViewDelegate

extension ProfileCellContentView: UIScrollViewDelegate {
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / kScreeenWidth)
        scrollViewDidScrollBlock?(index)
    }
}
