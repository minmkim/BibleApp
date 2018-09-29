//
//  BibleCoordinator.swift
//  BibleApp
//
//  Created by Min Kim on 9/15/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import Foundation
import UIKit

final class BibleCoordinator: Coordinator {
    
    let bibleViewController: BibleViewController!
    let bible: Bible!
    var currentChapter = 1
    var currentBook = ""
    weak var currentBookController: BookTableController?
    
    init(bibleViewController: BibleViewController, bible: Bible) {
        self.bibleViewController = bibleViewController
        self.bible = bible
        self.bibleViewController.bibleCoordinatorDelegate = self
    }
    
    deinit {
        currentBookController = nil
    }
    
    func loadBookTableController(verses: [String], book: String, chapter: Int) -> BookTableController {
        let controller = BookTableController()
        currentBookController = controller
        currentChapter = chapter
        currentBook = book
        controller.verseArray = verses
        controller.changeChapterDelegate = self
        controller.chapter = chapter
        controller.navigationItem.title = book
        guard let numberOfChapters = bible.bible[book]?.count else {return controller}
        controller.numberOfChapters = numberOfChapters
        return controller
    }
    
    func openBibleVerse(book: String, chapter: Int, verse: Int) {
        guard let dict = bible.bible[book] else {return}
        guard let verses = dict[chapter] else {return}
        let controller = loadBookTableController(verses: verses, book: book, chapter: chapter)
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
        let indexPath = IndexPath(item: verse - 1, section: 0)
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
    
    func openBibleWebsite(for indexPath: IndexPath) {
        let controller = BibleBookDetailViewController()
        if indexPath.section < bible.booksOfOldTestament.count {
            controller.book = bible.booksOfOldTestament[indexPath.section]
        } else {
            controller.book = bible.booksOfNewTestament[indexPath.section - bible.booksOfOldTestament.count]
        }
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openBibleChapter(book: String, chapter: Int) {
        guard let dict = bible.bible[book] else {return}
        guard let verses = dict[chapter] else {return}
        let controller = loadBookTableController(verses: verses, book: book, chapter: chapter)
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToNewChapter() {
        guard let bookDict = bible.bible[currentBook] else {return}
        guard let verses = bookDict[currentChapter] else {return}
        currentBookController?.verseArray = verses
        currentBookController?.chapter = currentChapter
        currentBookController?.newChapter()
    }
    
}

extension BibleCoordinator: ChangeChapterDelegate {
    func goToChapter(_ chapter: Int) {
        currentChapter = chapter
        goToNewChapter()
    }
    
    func previousChapter() {
        currentChapter -= 1
        goToNewChapter()
    }
    
    func nextChapter() {
        currentChapter += 1
        goToNewChapter()
    }
    
    
}
