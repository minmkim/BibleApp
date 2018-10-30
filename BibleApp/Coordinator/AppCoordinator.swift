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
}

final class AppCoordinator: Coordinator {
    
    enum coordinatorType {
        case bible
        case savedVerses
        case search
    }
    
    let window: UIWindow?
    var coordinatorDict = [coordinatorType: Coordinator]()
    lazy var verseDataManager = VersesDataManager()
    lazy var bible = Bible(verseDataManager: verseDataManager)
    
    lazy var rootViewController: MainViewController = {
        let controller = MainViewController()
        controller.tabBarController?.tabBar.barTintColor = .white
        controller.tabBarController?.tabBar.isTranslucent = false
        controller.tabSelectedDelegate = self
        return controller
    }()
    
    lazy var bibleViewController = BibleViewController()
    lazy var verseViewController: VerseViewController = {
        let controller = VerseViewController()
        controller.savedVerseController = SavedVerseController(dataManager: verseDataManager)
        return controller
    }()
    
    lazy var savedVerseViewController = SavedVerseViewController()
    lazy var searchViewController: SearchViewController = {
        let controller = SearchViewController()
        let searchController = VerseSearchController(bible: bible)
        controller.searchControllers = searchController
        searchController.updateSearchBarDelegate = controller
        return controller
    }()
    lazy var settingsViewController = SettingsTableViewController()
    
    init(window: UIWindow?) {
        self.window = window
        
        let navigationController1 = UINavigationController(rootViewController: bibleViewController)
        navigationController1.navigationBar.barTintColor = .white
        navigationController1.navigationBar.isTranslucent = false
        navigationController1.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController1.navigationBar.tintColor = UIColor(red: 236/255, green: 73/255, blue: 38/255, alpha: 1.0)
        bibleViewController.bible = self.bible
        bibleViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "literature"), tag: 0)
        bibleViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let navigationController2 = UINavigationController(rootViewController: verseViewController)
        navigationController2.navigationBar.prefersLargeTitles = true
        navigationController2.navigationBar.barTintColor = .white
        navigationController2.navigationBar.isTranslucent = false
        navigationController2.navigationBar.setValue(true, forKey: "hidesShadow")
        verseViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "for_you"), tag: 1)
        verseViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let navigationController3 = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "search"), tag: 2)
        searchViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        
        let navigationController4 = UINavigationController(rootViewController: settingsViewController)
        settingsViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "settings"), tag: 3)
        settingsViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)

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
    func didSelectTab(at index: Int) {
        switch index {
        case 0:
            if coordinatorDict[coordinatorType.bible] == nil {
                coordinatorDict = [:]
                let bibleCoordinator = BibleCoordinator(bibleViewController: bibleViewController, bible: bible)
                coordinatorDict[coordinatorType.bible] = bibleCoordinator
            } else {
                coordinatorDict[coordinatorType.savedVerses] = nil
                coordinatorDict[coordinatorType.search] = nil
            }
        case 1:
            if coordinatorDict[coordinatorType.savedVerses] == nil {
                if let coordinator = coordinatorDict[coordinatorType.bible] as? BibleCoordinator {
                    if coordinator.currentBookController != nil {
                        let verseCoordinator = VerseCoordinator(verseViewController: verseViewController)
                        verseCoordinator.bibleVerseDelegate = self
                        coordinatorDict[coordinatorType.savedVerses] = verseCoordinator
                        return
                    }
                }
                coordinatorDict = [:]
                let verseCoordinator = VerseCoordinator(verseViewController: verseViewController)
                verseCoordinator.bibleVerseDelegate = self
                coordinatorDict[coordinatorType.savedVerses] = verseCoordinator
            }
        case 2:
            if coordinatorDict[coordinatorType.search] == nil {
                if let coordinator = coordinatorDict[coordinatorType.bible] as? BibleCoordinator {
                    if coordinator.currentBookController != nil {
                        let searchCoordinator = SearchCoordinator(searchViewController: searchViewController, bible: bible)
                        searchCoordinator.bibleVerseDelegate = self
                        coordinatorDict[coordinatorType.search] = searchCoordinator
                        return
                    }
                }

                coordinatorDict = [:]
                let searchCoordinator = SearchCoordinator(searchViewController: searchViewController, bible: bible)
                searchCoordinator.bibleVerseDelegate = self
                coordinatorDict[coordinatorType.search] = searchCoordinator
            }
        case 3:
            if let coordinator = coordinatorDict[coordinatorType.bible] as? BibleCoordinator {
                if coordinator.currentBookController != nil {
                    coordinatorDict[coordinatorType.savedVerses] = nil
                    coordinatorDict[coordinatorType.search] = nil
                    return
                }
            } else {
                coordinatorDict = [:]
            }
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
