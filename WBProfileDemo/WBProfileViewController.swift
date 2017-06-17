//
//  WBProfileViewController.swift
//  WBProfileDemo
//
//  Created by 唐标 on 2017/6/14.
//  Copyright © 2017年 jackTang. All rights reserved.
//

import UIKit

public let kScreenHeight = UIScreen.main.bounds.height

public let kScreeenWidth = UIScreen.main.bounds.width

let kWBProfileViewControllerTableViewDidScrollNotification = "kWBProfileViewControllerTableViewDidScrollNotification"

//MARK: -- 自定义一个可以接收上层tableView手势的tableView
class TBCustomGestureTableView: UITableView, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let isShouldView: Bool? = otherGestureRecognizer.view?.isMember(of: UIScrollView.self)
        //如果是scrollView的手势，肯定是不能同时响应的
        if let isShouldView = isShouldView, isShouldView == true{
            return false
        }
        //    其它手势是collectionView 或者tableView的pan手势 ，那么就让它们同时响应
        let isPan = gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) && gestureRecognizer.isKind(of: UIPanGestureRecognizer.self)
        let isKindScrollView = otherGestureRecognizer.view?.isKind(of: UIScrollView.self)
        if let isKindScrollView = isKindScrollView, isKindScrollView && isPan {
            return true
        }
        return false
    }
}




//MARK: -- property and lifeCycle
class WBProfileViewController: UIViewController {
    
    public let headerViewHeight: CGFloat = 300.0
    
    fileprivate let sectionHeight: CGFloat = 44.0
    
    fileprivate let navigationHeight: CGFloat = 64.0
//    location the Y where navigationbar will change
    fileprivate var alphaChangeMaxY: CGFloat {
        get {
            return nameLabel.frame.maxY - 64
        }
    }

//    horizontalScrollView is did scroll  This will change childScrollView
    fileprivate var horizontalScrollViewIsChanged: Bool = false
    
    fileprivate var tableView: TBCustomGestureTableView!
    
    fileprivate var headerImageView: UIImageView!
    
    fileprivate var nameLabel: UILabel!
    
    fileprivate var iconButton: UIButton!
    
    fileprivate weak var childScrollView: UIScrollView!
    
    fileprivate var navigationBarView: UIView?
    
    fileprivate lazy var cellContentView: ProfileCellContentView = { [unowned self] _ in
       let contentView = ProfileCellContentView(frame: CGRect.init(x: 0, y: 0, width: kScreeenWidth, height: kScreenHeight - 44 - 64), superViewController: self)
        contentView.scrollViewDidScrollBlock = { (index) in
            if let childViewController = (self.childViewControllers[index] as? ProfileSubTableViewController) {
                self.segmentView.segmentedControl.selectedSegmentIndex = index
                self.horizontalScrollViewIsChanged = true
                self.childScrollView = childViewController.scrollView
            }
        }
        return contentView
    }()
    
    fileprivate lazy var segmentView: SegmentView = {[unowned self] _ in
        let segmentView = SegmentView(frame: CGRect(x: 0, y: 0, width: kScreeenWidth, height: self.sectionHeight))
        segmentView.segmentedControl.indexChangeBlock = { [unowned self] (index) in
            self.cellContentView.scrollView.contentOffset.x = kScreeenWidth * CGFloat(index)
            if let childViewController = (self.childViewControllers[index] as? ProfileSubTableViewController) {
                self.horizontalScrollViewIsChanged = true
                self.childScrollView = childViewController.scrollView
            }
        }
        return segmentView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        title = "路飞"
        NotificationCenter.default.addObserver(self, selector: #selector(subScrollViewNotification), name: NSNotification.Name(rawValue: kProfileSubTableViewControllerScrollViewDidScrollNotification), object: nil)
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        navigationBar?.shadowImage = UIImage()
        if navigationBarView == nil {
            navigationBarView = UIView(frame: CGRect(x: 0, y: -20, width: kScreeenWidth, height: navigationHeight))
            navigationBarView?.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
            navigationBarView?.backgroundColor = UIColor.clear
            navigationBar?.insertSubview(navigationBarView!, at: 0)
        }
        navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.clear]
    }
}

//MARK: --  setUp UI

extension WBProfileViewController {
    
    fileprivate func setUpTableView() {
        tableView = TBCustomGestureTableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = kScreenHeight - sectionHeight - navigationHeight
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.scrollsToTop = false
        tableView.sectionHeaderHeight = sectionHeight
        setUpTableViewHeaderView()
        view.addSubview(tableView)
    }
    
    fileprivate func setUpTableViewHeaderView() {
        
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreeenWidth, height: headerViewHeight))
        tableView.tableHeaderView = headView
        
        headerImageView = UIImageView(image: UIImage(named: "1.jpeg"))
        headerImageView.frame = headView.bounds
        //        This property must be set
        headerImageView.clipsToBounds = true
        headerImageView.contentMode = .scaleAspectFill
        headerImageView.alpha = 0.2
        headView.addSubview(headerImageView)
        
        iconButton = UIButton(type: .custom)
        iconButton.frame = CGRect(x: kScreeenWidth / 2 - 40, y: 100, width: 80, height: 80)
        iconButton.layer.masksToBounds = true
        iconButton.layer.cornerRadius = 40
        iconButton.setImage(UIImage(named: "1.jpeg"), for: .normal)
        headView.addSubview(iconButton)
        
        nameLabel = UILabel(frame: CGRect(x: kScreeenWidth / 2 - 50, y: iconButton.frame.maxY + 5, width: 100, height: 30))
        nameLabel.text = "路飞"
        nameLabel.textAlignment = NSTextAlignment.center
        headView.addSubview(nameLabel)
    }

}


//MARK: -- TableViewDelegate
extension WBProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "WBProfileTest")
        if let cell = cell {
            return cell
        }
        cell = UITableViewCell(style: .default, reuseIdentifier: "WBProfileTest")
        cell?.contentView.removeFromSuperview()
        cell?.addSubview(cellContentView)
        return cell!
    }
}


//MARK: -- Scroll Method
extension WBProfileViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if horizontalScrollViewIsChanged {
            horizontalScrollViewIsChanged = false
        }
        let contentOffset =  headerViewHeight - navigationHeight
        if let childScrollView = childScrollView, childScrollView.contentOffset.y > 0 && scrollView.contentOffset.y != contentOffset {
            scrollView.contentOffset.y = contentOffset
            
        } else if scrollView.contentOffset.y < contentOffset {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kWBProfileViewControllerTableViewDidScrollNotification), object: nil, userInfo: nil)
        }
        
        let scrollViewOffesetY = scrollView.contentOffset.y
        //      放大tableView headView的背景图
        if (scrollViewOffesetY <= 0) {
            let totalOffset = CGFloat(headerViewHeight) - scrollViewOffesetY;
            let f = totalOffset / headerViewHeight;
            headerImageView.frame = CGRect.init(x: -(kScreeenWidth * f - kScreeenWidth) / 2, y: scrollViewOffesetY, width: kScreeenWidth * f, height: totalOffset)
        }
        
        //        变化自定义导航栏的透明度
        let maxContentOffsetY = contentOffset
        let minContentOffsetY = alphaChangeMaxY
        if scrollViewOffesetY >= minContentOffsetY {
    
            let alpha = (scrollViewOffesetY - minContentOffsetY) / (maxContentOffsetY - minContentOffsetY)
            navigationBarView?.backgroundColor = UIColor.init(white: 1.0, alpha: alpha)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 0, alpha: alpha)]

        } else {
            navigationBarView?.backgroundColor = UIColor.init(white: 1.0, alpha: 0.0)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.init(white: 0, alpha: 0.0)]
            
        }
        
        //        当大于60的时候就开始刷新数据  如果需要刷新数据 可以参考下面的代码
//        if scrollView.contentOffset.y < CGFloat(-60) && isNeedRefrash {
//            isNeedRefrash = false
//            loadDetailData()
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kFVUserProfileViewControllerRefreshDataNotifiCation), object: nil)
//        }
//        if scrollView.contentOffset.y == CGFloat(0) {
//            isNeedRefrash = true
//        }

    }
    
    
    func subScrollViewNotification(_ notification: Notification) {
        // 有个时候明明已经滚动过来了  但是这个childScrollView却还是上一个的
        if !horizontalScrollViewIsChanged {
            childScrollView = notification.userInfo![kProfileSubTableViewControllerSubScrollViewInfo] as? UIScrollView
        }
        
        let offsetHeight = headerViewHeight - navigationHeight
        
        if tableView.contentOffset.y < offsetHeight{
            childScrollView?.contentOffset = CGPoint.zero
        } else {
            tableView.contentOffset.y = offsetHeight
        }
    }
}




