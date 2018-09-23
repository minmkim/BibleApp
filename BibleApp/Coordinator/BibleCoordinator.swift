//
//  BibleCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

class BibleCoordinator: Coordinator {
    
    let bibleViewController: BibleViewController!
    let bible: Bible!
    
    init(bibleViewController: BibleViewController, bible: Bible) {
        print("init bible coordinator")
        self.bibleViewController = bibleViewController
        self.bible = bible
        self.bibleViewController.bibleCoordinatorDelegate = self
    }
    
    deinit {
        print("deinit bible")
    }
    
    func start() {
    }
    
    func openBibleVerse(book: String, chapter: Int, verse: Int) {
        guard let dict = bible.bible[book] else {return}
        let controller = BookTableController()
        controller.bookDict = dict
        controller.navigationItem.title = book
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
        let indexPath = IndexPath(item: verse - 1, section: chapter - 1)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            controller.bookTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            controller.bookTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            let _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { timer in
                controller.bookTableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}

extension BibleCoordinator: BibleCoordinatorDelegate {
    func openBibleBook(for indexPath: IndexPath) {
        var book = ""
        if indexPath.section < bible.booksOfOldTestament.count {
            book = bible.booksOfOldTestamentStrings[indexPath.section]
        } else {
            book = bible.booksOfNewTestamentStrings[indexPath.section - bible.booksOfOldTestament.count]
        }
        guard let dict = bible.bible[book] else {return}
        let controller = BookTableController()
        controller.bookDict = dict
        controller.navigationItem.title = book
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openBibleWebsite(for indexPath: IndexPath) {
        let controller = BibleBookDetailViewController()
        if indexPath.section < bible.booksOfOldTestament.count {
            controller.book = bible.booksOfOldTestamentStrings[indexPath.section]
        } else {
            controller.book = bible.booksOfNewTestamentStrings[indexPath.section - bible.booksOfOldTestament.count]
        }
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
