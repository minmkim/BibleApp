//
//  MainViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/7/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    let bible = Bible()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        let bibleViewController = BibleViewController()
        bibleViewController.bible = self.bible
        let navigationController1 = UINavigationController(rootViewController: bibleViewController)
        bibleViewController.tabBarItem = UITabBarItem(title: "Bible", image: UIImage(named: "literature"), tag: 0)
        
        let verseViewController = VerseViewController()
        let navigationController2 = UINavigationController(rootViewController: verseViewController)
        verseViewController.tabBarItem = UITabBarItem(title: "Verses", image: UIImage(named: "for_you"), tag: 1)
        
        let searchViewController = SearchViewController(style: .plain, bible: bible)
        let navigationController3 = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
        
        let settingsViewController = SettingsTableViewController()
        let navigationController4 = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 3)
        
        viewControllers = [navigationController1, navigationController2, navigationController3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
