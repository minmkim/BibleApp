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
        print("deinit biblecoordinator")
        currentBookController = nil
    }
    
    func loadBookTableController(verses: [String], book: String, chapter: Int) -> BookTableController {
        let controller = BookTableController()
        currentBookController = controller
        currentChapter = chapter
        currentBook = book
        controller.verseArray = verses
        controller.changeChapterDelegate = self
        controller.currentChapter = chapter
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
    
    func goToNextBook() {
        if let index = bible.booksOfOldTestament.firstIndex(of: currentBook) {
            if index < 38 {
                let book = bible.booksOfOldTestament[index + 1]
                currentBook = book
                currentChapter = 1
                currentBookController?.navigationItem.title = book
                guard let numberOfChapters = bible.bible[book]?.count else {return}
                currentBookController?.numberOfChapters = numberOfChapters
                currentBookController?.currentChapter = 1
                goToNewChapter()
            } else { // last book of old testament then go to new testament
                let book = bible.booksOfNewTestament[0]
                currentBook = book
                currentChapter = 1
                currentBookController?.navigationItem.title = book
                guard let numberOfChapters = bible.bible[book]?.count else {return}
                currentBookController?.numberOfChapters = numberOfChapters
                currentBookController?.currentChapter = 1
                goToNewChapter()
            }
            return
        }
        if let index = bible.booksOfNewTestament.firstIndex(of: currentBook) {
            if index != 38 { // Revelation
                let book = bible.booksOfNewTestament[index + 1]
                currentBook = book
                currentChapter = 1
                currentBookController?.navigationItem.title = book
                guard let numberOfChapters = bible.bible[book]?.count else {return}
                currentBookController?.numberOfChapters = numberOfChapters
                currentBookController?.currentChapter = 1
                goToNewChapter()
                return
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
        currentBookController?.currentChapter = currentChapter
        currentBookController?.newChapter()
    }
    
}

extension BibleCoordinator: ChangeChapterDelegate {
    func closedController() {
//        currentBookController = nil
    }
    
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
        if let chapters = bible.bible[currentBook] {
            if currentChapter > chapters.count {
                goToNextBook()
            }
        }
        goToNewChapter()
    }
    
    
}
