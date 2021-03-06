//
//  AppDelegate.swift
//  BibleApp
//
//  Created by Min Kim on 8/6/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit
import CoreData
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!
    var launchedShortcutItem: UIApplicationShortcutItem?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        checkPreloadedData()
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window, persistentContainer: persistentContainer)
        appCoordinator.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        requestSiriAccess()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MtZion")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func checkPreloadedData() {
        let didPreloadCoreData = UserDefaults.standard.bool(forKey: "DidPreloadCoreData")
        if !didPreloadCoreData {
            preloadDBData()
            UserDefaults.standard.set(true, forKey: "DidPreloadCoreData")
        }
    }
    
    func requestSiriAccess() {
        var numberOfOpen = UserDefaults.standard.integer(forKey: "numberOfOpens")
        if numberOfOpen < 6 {
            numberOfOpen += 1
            UserDefaults.standard.set(numberOfOpen, forKey: "numberOfOpens")
        } else {
            INPreferences.requestSiriAuthorization
                {
                    (authStatus: INSiriAuthorizationStatus) in
            }
        }
    }
    
    func preloadDBData() {
        let sqlitePath = Bundle.main.path(forResource: "MtZion", ofType: "sqlite")
        let sqlitePath_shm = Bundle.main.path(forResource: "MtZion", ofType: "sqlite-shm")
        let sqlitePath_wal = Bundle.main.path(forResource: "MtZion", ofType: "sqlite-wal")
        
        let URL1 = URL(fileURLWithPath: sqlitePath!)
        let URL2 = URL(fileURLWithPath: sqlitePath_shm!)
        let URL3 = URL(fileURLWithPath: sqlitePath_wal!)
        let URL4 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite")
        let URL5 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite-shm")
        let URL6 = URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite-wal")
        
        if !FileManager.default.fileExists(atPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/MtZion.sqlite") {
            // Copy 3 files
            do {
                try FileManager.default.copyItem(at: URL1, to: URL4)
                try FileManager.default.copyItem(at: URL2, to: URL5)
                try FileManager.default.copyItem(at: URL3, to: URL6)
                
                print("=======================")
                print("FILES COPIED")
                print("=======================")
                
            } catch {
                print("=======================")
                print("ERROR IN COPY OPERATION")
                print("=======================")
            }
        } else {
            print("=======================")
            print("FILES EXIST")
            print("=======================")
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcutItem(withShortcutItem: shortcutItem))
    }
    
    func handleShortcutItem(withShortcutItem item: UIApplicationShortcutItem) -> Bool {
        guard let shortcutType = item.type.components(separatedBy: ".").last else { return false }
        guard let mainView = self.window?.rootViewController as? MainViewController else {return false}
        switch shortcutType {
        case "Bible":
            let index = 0
            mainView.selectedIndex = index
            appCoordinator.didSelectTab(at: index)
        case "SavedVerses":
            let index = 1
            mainView.selectedIndex = index
            appCoordinator.didSelectTab(at: index)
        case "Search":
            let index = 2
            mainView.selectedIndex = index
            appCoordinator.didSelectTab(at: index)
        default:
            mainView.selectedIndex = 0
        }
        return false
    }

}

