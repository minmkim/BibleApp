//
//  MainViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/7/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    weak var tabSelectedDelegate: TabSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MainViewController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let title = item.title else {return}
        tabSelectedDelegate?.didSelectTab(at: title)
    }
}

protocol TabSelectedDelegate: class {
    func didSelectTab(at tab: String)
}
