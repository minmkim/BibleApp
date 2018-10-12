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
        guard let numberOfChapters = bible.numberOfChaptersInBook(for: book) else {return controller}
        controller.numberOfChapters = numberOfChapters
        return controller
    }
    
    func openBibleVerse(book: String, chapter: Int, verse: Int) {
        guard let dict = bible.returnBookDict(for: book) else {return}
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
        guard let index = bible.bookIndex(for: currentBook) else {return}
        
        guard let book = bible.returnNextBook(for: index) else {return}
        currentBookController?.navigationItem.title = book
        currentBook = book
        currentChapter = 1
        guard let numberOfChapters = bible.numberOfChaptersInBook(for: book) else {return}
        currentBookController?.numberOfChapters = numberOfChapters
        currentBookController?.currentChapter = 1
        goToNewChapter()
    }
    
    func goToPreviousBook() {
        guard let index = bible.bookIndex(for: currentBook) else {return}
        guard let book = bible.returnPreviousBook(for: index) else {return}
        guard let numberOfChapters = bible.numberOfChaptersInBook(for: book) else {return}
        currentBook = book
        currentChapter = numberOfChapters
        currentBookController?.navigationItem.title = book
        currentBookController?.numberOfChapters = numberOfChapters
        currentBookController?.currentChapter = currentChapter
        goToNewChapter()
    }
    
}

extension BibleCoordinator: BibleCoordinatorDelegate {
    
    func openBibleWebsite(for indexPath: IndexPath) {
        let controller = BibleBookDetailViewController()
        controller.book = bible.returnBook(for: indexPath.section)
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openBibleChapter(book: String, chapter: Int) {
        guard let dict = bible.returnBookDict(for: book) else {return}
        guard let verses = dict[chapter] else {return}
        let controller = loadBookTableController(verses: verses, book: book, chapter: chapter)
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToNewChapter() {
        guard let bookDict = bible.returnBookDict(for: currentBook) else {return}
        guard let verses = bookDict[currentChapter] else {return}
        currentBookController?.verseArray = verses
        currentBookController?.currentChapter = currentChapter
        currentBookController?.newChapter()
    }
    
}

extension BibleCoordinator: ChangeChapterDelegate {
    func closedController() {
//
    }
    
    
    func goToChapter(_ chapter: Int) {
        currentChapter = chapter
        goToNewChapter()
    }
    
    func previousChapter() {
        if currentChapter == 1 {
            goToPreviousBook()
        } else {
            currentChapter -= 1
            goToNewChapter()
        }
    }
    
    func nextChapter() {
        if let chapters = bible.numberOfChaptersInBook(for: currentBook) {
            if currentChapter >= chapters {
                goToNextBook()
                return
            } else {
                currentChapter += 1
                goToNewChapter()
                return
            }
        }
    }
    
    
}
