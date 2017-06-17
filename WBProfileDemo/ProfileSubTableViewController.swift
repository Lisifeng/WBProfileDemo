//
//  ProfileSubTableViewController.swift
//  WBProfileDemo
//
//  Created by 唐标 on 2017/6/14.
//  Copyright © 2017年 jackTang. All rights reserved.
//

import UIKit

let kProfileSubTableViewControllerScrollViewDidScrollNotification = "kProfileSubTableViewControllerScrollViewDidScrollNotification"
let kProfileSubTableViewControllerSubScrollViewInfo = "kProfileSubTableViewControllerSubScrollViewInfo"

class ProfileSubTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
    }
    weak var scrollView: UIScrollView?
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.scrollView == nil {
            self.scrollView = scrollView
        }

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kProfileSubTableViewControllerScrollViewDidScrollNotification), object: nil, userInfo: [kProfileSubTableViewControllerSubScrollViewInfo : scrollView])
    }
    
    func addNotification() {
//         super TabelView is scroll
        NotificationCenter.default.addObserver(self, selector: #selector(superScrollViewDidScroll(_:)), name: NSNotification.Name(rawValue: kWBProfileViewControllerTableViewDidScrollNotification), object: nil)
    }
    
    func superScrollViewDidScroll(_ notification: NSNotification) {
        self.scrollView?.contentOffset = CGPoint.zero
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}



// MARK: - Table view delegate
extension ProfileSubTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if let cell = cell {
            return cell
        }
        cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        
        cell?.backgroundColor = view.backgroundColor
        return cell!
    }
}
