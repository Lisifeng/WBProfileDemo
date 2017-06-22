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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 200
        tableView.register(UINib.init(nibName: "SubTableViewCell", bundle: nil), forCellReuseIdentifier: "SubTableViewCell")
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
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTableViewCell") as! SubTableViewCell
        cell.iconImageView.image = UIImage.init(named: "\(indexPath.row + 2)")
        cell.subTitleLabel.text = title
        return cell
    }
}
