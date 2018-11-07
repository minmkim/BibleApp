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
    var currentBookController: BookTableController?
    var savedVersesController: SavedVersesController!
    
    init(bibleViewController: BibleViewController, bible: Bible, savedVersesController: SavedVersesController) {
        self.savedVersesController = savedVersesController
        self.bibleViewController = bibleViewController
        self.bible = bible
        self.bibleViewController.bibleCoordinatorDelegate = self
    }
    
    deinit {
        print("deinit biblecoordinator")
        currentBookController = nil
    }
    
    func loadBookTableController(book: String, chapter: Int, version: String) -> BookTableController {
        let controller = BookTableController()
        controller.savedVersesController = savedVersesController
        currentBookController = controller
        currentChapter = chapter
        currentBook = book
        guard let numberOfChapters = self.bible.numberOfChaptersInBook(for: book) else {return controller}
        controller.setupController(numberOfChapters: numberOfChapters, currentChapter: chapter, book: book)
        bible.getBibleBook(book, forChapter: chapter, version: version) { (fetchedVerses) in
            DispatchQueue.main.async {
                controller.verseArray = fetchedVerses
                controller.bookTableView.reloadData()
                controller.setupIndexList(for: fetchedVerses.count)
            }
        }
        controller.changeChapterDelegate = self
        controller.saveVerseDelegate = self
        controller.navigationItem.title = book
        return controller
    }
    
    func openBibleVerse(book: String, chapter: Int, verse: Int, version: String) {
        let controller = loadBookTableController(book: book, chapter: chapter, version: version)
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
        let version = UserDefaults.standard.string(forKey: "BibleVersion") ?? "NIV1984"
        let controller = loadBookTableController(book: book, chapter: chapter, version: version)
        bibleViewController.navigationController?.pushViewController(controller, animated: true)
    }
    
    func goToNewChapter() {
        let version = UserDefaults.standard.string(forKey: "BibleVersion") ?? "NIV1984"
        bible.getBibleBook(currentBook, forChapter: currentChapter, version: version) { (fetchedVerses) in
            currentBookController?.verseArray = fetchedVerses
            currentBookController?.currentChapter = currentChapter
            currentBookController?.newChapter()
        }
        
    }
    
}

extension BibleCoordinator: SaveVerseDelegate {
    func presentSaveVerses() {
        let controller = SavedVerseViewController(state: .search, savedVersesModel: savedVersesController)
        controller.didSelectNoteDelegate = currentBookController
        controller.createNewNoteDelegate = currentBookController
        currentBookController?.present(controller, animated: true, completion: nil)
    }
    
    
}

extension BibleCoordinator: ChangeChapterDelegate {
    func closeController() {
        bibleViewController.navigationController?.popViewController(animated: false)
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
