//
//  AppCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    enum coordinatorType {
        case bible
        case savedVerses
        case search
    }
    
    let window: UIWindow?
    var coordinatorDict = [coordinatorType: Coordinator]()
    
    let bible = Bible()
    
    lazy var rootViewController: MainViewController = {
        let controller = MainViewController()
        controller.tabSelectedDelegate = self
        return controller
    }()
    
    lazy var bibleViewController = BibleViewController()
    lazy var verseViewController = VerseViewController()
    lazy var searchViewController: SearchViewController = {
        let controller = SearchViewController()
        controller.searchViewModel = SearchViewModel(bible: bible)
        return controller
    }()
    lazy var settingsViewController = SettingsTableViewController()
    
    init(window: UIWindow?) {
        self.window = window
        
        let navigationController1 = UINavigationController(rootViewController: bibleViewController)
        bibleViewController.bible = self.bible
        bibleViewController.tabBarItem = UITabBarItem(title: "Bible", image: UIImage(named: "literature"), tag: 0)
        
        let navigationController2 = UINavigationController(rootViewController: verseViewController)
        verseViewController.tabBarItem = UITabBarItem(title: "Verses", image: UIImage(named: "for_you"), tag: 1)
        
        let navigationController3 = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search"), tag: 2)
        
        let navigationController4 = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 3)
        
        rootViewController.viewControllers = [navigationController1, navigationController2, navigationController3, navigationController4]
    }
    
    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        let bibleCoordinator = BibleCoordinator(bibleViewController: bibleViewController, bible: bible)
        coordinatorDict[coordinatorType.bible] = bibleCoordinator
    }
    
}

extension AppCoordinator: TabSelectedDelegate {
    func didSelectTab(at tab: String) {
        switch tab {
        case "Bible":
            if coordinatorDict[coordinatorType.bible] == nil {
                coordinatorDict = [:]
                let bibleCoordinator = BibleCoordinator(bibleViewController: bibleViewController, bible: bible)
                coordinatorDict[coordinatorType.bible] = bibleCoordinator
            }
        case "Verses":
            if coordinatorDict[coordinatorType.savedVerses] == nil {
                coordinatorDict = [:]
                let verseCoordinator = VerseCoordinator(verseViewController: verseViewController)
                verseCoordinator.bibleVerseDelegate = self
                coordinatorDict[coordinatorType.savedVerses] = verseCoordinator
            }
        case "Search":
            if coordinatorDict[coordinatorType.search] == nil {
                coordinatorDict = [:]
                let searchCoordinator = SearchCoordinator(searchViewController: searchViewController)
                searchCoordinator.bibleVerseDelegate = self
                coordinatorDict[coordinatorType.search] = searchCoordinator
            }
        case "Settings":
            coordinatorDict = [:]
        default:
            print("default")
            
        }
    }
}

extension AppCoordinator: BibleVerseDelegate {
    func openBibleVerse(book: String, chapter: Int, verse: Int) {
        coordinatorDict = [:]
        let bibleCoordinator = BibleCoordinator(bibleViewController: bibleViewController, bible: bible)
        coordinatorDict[coordinatorType.bible] = bibleCoordinator
        bibleViewController.navigationController?.popToRootViewController(animated: false)
        rootViewController.selectedIndex = 0
        bibleCoordinator.openBibleVerse(book: book, chapter: chapter, verse: verse)
    }
}
